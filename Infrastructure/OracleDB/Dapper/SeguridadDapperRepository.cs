using Application.DTOs;
using Application.Interface;
using Application.Results;
using Dapper;
using System;
using System.Collections.Generic;
using System.Text;

namespace Infrastructure.OracleDB.Dapper;

public class SeguridadDapperRepository : ISeguridadRepository
{
    private readonly OracleConnectionFactory _factory;

    public SeguridadDapperRepository(OracleConnectionFactory factory)
    {
        _factory = factory;
    }

    public async Task<ApiResponse<UsuarioDto>> RegistrarAsync(RegisterUserRequest req)
    {
        using var conn = _factory.Create();

        var existe = await conn.ExecuteScalarAsync<int>(
            "SELECT COUNT(1) FROM SEGURIDAD.USUARIOS WHERE USERNAME = :username",
            new { username = req.Username });

        if (existe > 0)
        {
            return new ApiResponse<UsuarioDto>
            (
               "INFO",
                "El usuario ya existe",
                Array.Empty<UsuarioDto>()
            );
         };


        var id = await conn.ExecuteScalarAsync<int>(
            @"INSERT INTO SEGURIDAD.USUARIOS (USUARIO_ID, USERNAME, PASSWORD_HASH)
          VALUES (SEGURIDAD.SEQ_USUARIOS.NEXTVAL, :username, :password)
          RETURNING USUARIO_ID INTO :id",
            new
            {
                username = req.Username,
                password = BCrypt.Net.BCrypt.HashPassword(req.PasswordHash),
                id = 0
            });

        return new ApiResponse<UsuarioDto>(
            "SUCCESS",
            "Usuario creado correctamente",
            new[]
            {
                new UsuarioDto
                (
                   id,
                   req.Username
                )
        }
    );

    }

    public async Task<ApiResponse<LoginDbDto>> LoginAsync(LoginRequest req)
    {
        using var conn = _factory.Create();

        var user = await conn.QueryFirstOrDefaultAsync<LoginDbDto>(
            @"SELECT USUARIO_ID   AS UsuarioId,
                 USERNAME     AS Username,
                 PASSWORD_HASH AS PasswordHash
          FROM SEGURIDAD.USUARIOS
          WHERE USERNAME = :username
            AND ACTIVO = 'S'",
            new { username = req.Username });

        if (user == null)
        {
            return new ApiResponse<LoginDbDto>
            (
                 "INFO",
                "Credenciales inválidas",
                Array.Empty<LoginDbDto>()
            );
        }

        return new ApiResponse<LoginDbDto>
        (
            "SUCCESS",
           "Usuario encontrado",
            new[] { user }
        );
    }

}