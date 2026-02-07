using Application.DTOs;
using Application.Interface;
using Application.Results;
using Infrastructure.OracleDB.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Text.Json;
using Oracle.ManagedDataAccess.Types;
using BCrypt.Net;
using Oracle.ManagedDataAccess.Client;


namespace Infrastructure.OracleDB.SP;



public class SeguridadSpRepository : ISeguridadRepository
{
    private readonly OracleConnection _connection;

    public SeguridadSpRepository(OracleConnection connection)
    {
        _connection = connection;
    }

    public async Task<ApiResponse<UsuarioDto>> RegistrarAsync(RegisterUserRequest req)
    {
        var jsonIn = JsonSerializer.Serialize(new
        {
            username = req.Username,
            passwordHash = BCrypt.Net.BCrypt.HashPassword(req.PasswordHash)
        });

        using var cmd = _connection.CreateCommand();
        cmd.CommandText = "seguridad.pkg_seguridad.crear_usuario_json";
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.Add("p_json_in", OracleDbType.Clob).Value = jsonIn;
        cmd.Parameters.Add("p_json_out", OracleDbType.Clob)
            .Direction = ParameterDirection.Output;

        await cmd.ExecuteNonQueryAsync();

        var clob = (Oracle.ManagedDataAccess.Types.OracleClob)
              cmd.Parameters["p_json_out"].Value;

        var jsonOut = clob.Value;

        return JsonSerializer.Deserialize<ApiResponse<UsuarioDto>>(jsonOut)!;
    }

    public async Task<ApiResponse<LoginDbDto>> LoginAsync(LoginRequest req)
    {
        var jsonIn = JsonSerializer.Serialize(new
        {
            username = req.Username
        });

        using var cmd = _connection.CreateCommand();
        cmd.CommandText = "seguridad.pkg_seguridad.login_json";
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.Add("p_json_in", OracleDbType.Clob).Value = jsonIn;
        cmd.Parameters.Add("p_json_out", OracleDbType.Clob)
            .Direction = ParameterDirection.Output;

        await cmd.ExecuteNonQueryAsync();

        var clob = (Oracle.ManagedDataAccess.Types.OracleClob)
            cmd.Parameters["p_json_out"].Value;

        var jsonOut = clob.Value;

        return JsonSerializer.Deserialize<ApiResponse<LoginDbDto>>(jsonOut)!;
    }



}