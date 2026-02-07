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
        using var conn = _factory.Create();

        var existe = await conn.ExecuteScalarAsync<int>(
            "SELECT COUNT(1) FROM INVENTARIO.PRODUCTOS WHERE CODIGO = :codigo",
            new { codigo = req.Codigo });

        if (existe > 0)
        {
            return new ApiResponse<ProductoDto>(
                "INFO",
                "El código del producto ya existe",
                Array.Empty<ProductoDto>()
            );
        }

        var id = await conn.ExecuteScalarAsync<int>(
            @"INSERT INTO INVENTARIO.PRODUCTOS (PRODUCTO_ID, CODIGO, NOMBRE)
          VALUES (INVENTARIO.SEQ_PRODUCTOS.NEXTVAL, :codigo, :nombre)
          RETURNING PRODUCTO_ID INTO :id",
            new
            {
                codigo = req.Codigo,
                nombre = req.Nombre,
                id = 0
            });

        await conn.ExecuteAsync(
            @"INSERT INTO INVENTARIO.PRODUCTO_DETALLE (PRODUCTO_ID, STOCK_ACTUAL)
          VALUES (:id, 0)",
            new { id });

        return new ApiResponse<ProductoDto>(
            "SUCCESS",
            "Producto creado correctamente",
          Array.Empty<ProductoDto>()
        );
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
                @"INSERT INTO INVENTARIO.ENTRADAS (PRODUCTO_ID, CANTIDAD, USUARIO)
              VALUES (:id, :cantidad, :usuario)",
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
                @"INSERT INTO INVENTARIO.SALIDAS (PRODUCTO_ID, CANTIDAD, USUARIO)
              VALUES (:id, :cantidad, :usuario)",
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