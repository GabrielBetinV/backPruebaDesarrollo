using Application.DTOs;
using Application.Interface;
using Application.Results;
using Dapper;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Text;

namespace Infrastructure.OracleDB.Dapper;

public class InventarioDapperRepository : IInventarioRepository
{
    private readonly OracleConnectionFactory _factory;

    public InventarioDapperRepository(OracleConnectionFactory factory)
    {
        _factory = factory;
    }

    public async Task<ApiResponse<ProductoDto>> CrearProductoAsync(CrearProductoRequest req)
    {
        using var conn = (OracleConnection)_factory.Create();
        await conn.OpenAsync();

        using var tx = conn.BeginTransaction();

        try
        {
            var existe = await conn.ExecuteScalarAsync<int>(
                "SELECT COUNT(1) FROM INVENTARIO.PRODUCTOS WHERE CODIGO = :codigo",
                new { codigo = req.Codigo }, tx);

            if (existe > 0)
            {
                return new ApiResponse<ProductoDto>(
                    "INFO",
                    "El código del producto ya existe",
                    Array.Empty<ProductoDto>()
                );
            }

            var p = new DynamicParameters();
            p.Add("codigo", req.Codigo);
            p.Add("nombre", req.Nombre);
            p.Add("usuario", req.Usuario);
            p.Add("id", dbType: System.Data.DbType.Int32,
                        direction: System.Data.ParameterDirection.Output);

            await conn.ExecuteAsync(
                @"INSERT INTO INVENTARIO.PRODUCTOS
              (PRODUCTO_ID, CODIGO, NOMBRE, USUARIO_CREACION, FECHA_CREACION)
              VALUES
              (INVENTARIO.SEQ_PRODUCTOS.NEXTVAL, :codigo, :nombre, :usuario, SYSDATE)
              RETURNING PRODUCTO_ID INTO :id",
                p, tx);

            var productoId = p.Get<int>("id");

            await conn.ExecuteAsync(
                @"INSERT INTO INVENTARIO.PRODUCTO_DETALLE
              (DETALLE_ID, PRODUCTO_ID, STOCK_ACTUAL)
              VALUES
              (INVENTARIO.SEQ_PRODUCTO_DETALLE.NEXTVAL, :productoId, 0)",
                new { productoId }, tx);

            tx.Commit();

            return new ApiResponse<ProductoDto>(
                "SUCCESS",
                "Producto creado correctamente",
                Array.Empty<ProductoDto>()
            );
        }
        catch (Exception ex)
        {
            tx.Rollback();

            return new ApiResponse<ProductoDto>(
                "ERROR",
                ex.Message,
                Array.Empty<ProductoDto>()
            );
        }
    }


    public async Task<ApiResponse<EmptyDto>> EntradaAsync(MovimientoRequest req)
    {
        using var conn = (OracleConnection)_factory.Create();
        await conn.OpenAsync();
        using var tx = conn.BeginTransaction();

        try
        {
            await conn.ExecuteAsync(
                @"UPDATE INVENTARIO.PRODUCTO_DETALLE
              SET STOCK_ACTUAL = STOCK_ACTUAL + :cantidad
              WHERE PRODUCTO_ID = :id",
                new { cantidad = req.Cantidad, id = req.ProductoId }, tx);

            await conn.ExecuteAsync(
                @"INSERT INTO INVENTARIO.ENTRADAS (PRODUCTO_ID, CANTIDAD, USUARIO, ENTRADA_ID)
              VALUES (:id, :cantidad, :usuario, INVENTARIO.seq_entradas.NEXTVAL)",
                new
                {
                    id = req.ProductoId,
                    cantidad = req.Cantidad,
                    usuario = req.Usuario
                }, tx);

            tx.Commit();

            return new ApiResponse<EmptyDto>(
                "SUCCESS",
                "Entrada registrada correctamente",
                Array.Empty<EmptyDto>()
            );
        }
        catch (Exception ex)
        {
            tx.Rollback();

            return new ApiResponse<EmptyDto>(
                "ERROR",
                ex.Message,
                Array.Empty<EmptyDto>()
            );
        }
    }


    public async Task<ApiResponse<EmptyDto>> SalidaAsync(MovimientoRequest req)
    {
        using var conn = (OracleConnection)_factory.Create();
        await conn.OpenAsync();
        using var tx = conn.BeginTransaction();

        var stock = await conn.ExecuteScalarAsync<int>(
            "SELECT STOCK_ACTUAL FROM INVENTARIO.PRODUCTO_DETALLE WHERE PRODUCTO_ID = :id",
            new { id = req.ProductoId }, tx);

        if (stock < req.Cantidad)
        {
            return new ApiResponse<EmptyDto>(
                "INFO",
                "Stock insuficiente",
                Array.Empty<EmptyDto>()
            );
        }

        try
        {
            await conn.ExecuteAsync(
                @"UPDATE INVENTARIO.PRODUCTO_DETALLE
              SET STOCK_ACTUAL = STOCK_ACTUAL - :cantidad
              WHERE PRODUCTO_ID = :id",
                new { cantidad = req.Cantidad, id = req.ProductoId }, tx);

            await conn.ExecuteAsync(
                @"INSERT INTO INVENTARIO.SALIDAS (PRODUCTO_ID, CANTIDAD, USUARIO, SALIDA_ID)
              VALUES (:id, :cantidad, :usuario, INVENTARIO.seq_salidas.NEXTVAL)",
                new
                {
                    id = req.ProductoId,
                    cantidad = req.Cantidad,
                    usuario = req.Usuario
                }, tx);

            tx.Commit();

            return new ApiResponse<EmptyDto>(
                "SUCCESS",
                "Salida registrada correctamente",
                Array.Empty<EmptyDto>()
            );
        }
        catch (Exception ex)
        {
            tx.Rollback();

            return new ApiResponse<EmptyDto>(
                "ERROR",
                ex.Message,
                Array.Empty<EmptyDto>()
            );
        }
    }



    public async Task<ApiResponse<ProductoStockDto>> ListarProductosAsync()
    {
        using var conn = _factory.Create();

        var productos = await conn.QueryAsync<ProductoStockDto>(
            @"SELECT 
              p.PRODUCTO_ID   AS ProductoId,
              p.CODIGO        AS Codigo,
              p.NOMBRE        AS Nombre,
              d.STOCK_ACTUAL  AS StockActual
          FROM INVENTARIO.PRODUCTOS p
          JOIN INVENTARIO.PRODUCTO_DETALLE d
            ON d.PRODUCTO_ID = p.PRODUCTO_ID
          ORDER BY p.CODIGO");

        return new ApiResponse<ProductoStockDto>(
            "SUCCESS",
            "Listado de productos",
            productos.AsList()
        );
    }


}