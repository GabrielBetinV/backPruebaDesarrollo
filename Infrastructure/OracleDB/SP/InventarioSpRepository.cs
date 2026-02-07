using Application.DTOs;
using Application.Interface;
using Application.Results;
using Infrastructure.OracleDB.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Text.Json;

namespace Infrastructure.OracleDB.SP;

public class InventarioSpRepository : IInventarioRepository
{
    private readonly OracleConnection _connection;

    public InventarioSpRepository(OracleConnection connection)
    {
        _connection = connection;
    }

    private async Task<ApiResponse<T>> ExecuteAsync<T>(
        string spName, object payload)
    {
        using var cmd = _connection.CreateCommand();
        cmd.CommandText = spName;
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.Add("p_json_in", OracleDbType.Clob)
            .Value = JsonSerializer.Serialize(payload);

        cmd.Parameters.Add("p_json_out", OracleDbType.Clob)
            .Direction = ParameterDirection.Output;

        await cmd.ExecuteNonQueryAsync();

        var clob = (Oracle.ManagedDataAccess.Types.OracleClob)
             cmd.Parameters["p_json_out"].Value;

        var jsonOut = clob.Value;

        return JsonSerializer.Deserialize<ApiResponse<T>>(jsonOut)!;
    }

    public Task<ApiResponse<ProductoDto>> CrearProductoAsync(CrearProductoRequest r) =>
        ExecuteAsync<ProductoDto>("inventario.pkg_inventario.crear_producto_json", r);

    public Task<ApiResponse<EmptyDto>> EntradaAsync(MovimientoRequest r) =>
        ExecuteAsync<EmptyDto>("inventario.pkg_inventario.entrada_json", r);

    public Task<ApiResponse<EmptyDto>> SalidaAsync(MovimientoRequest r) =>
        ExecuteAsync<EmptyDto>("inventario.pkg_inventario.salida_json", r);


    public async Task<ApiResponse<ProductoStockDto>> ListarProductosAsync()
    {
        using var cmd = _connection.CreateCommand();
        cmd.CommandText = "inventario.pkg_inventario.listar_productos_stock_json";
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.Add("p_json_out", OracleDbType.Clob)
                      .Direction = ParameterDirection.Output;

        await cmd.ExecuteNonQueryAsync();


        var clob = (Oracle.ManagedDataAccess.Types.OracleClob)
             cmd.Parameters["p_json_out"].Value;

        var jsonOut = clob.Value;

        return JsonSerializer.Deserialize<ApiResponse<ProductoStockDto>>(jsonOut)!;
    }
}