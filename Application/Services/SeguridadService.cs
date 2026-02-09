using Application.DTOs;
using Application.Interface;
using Application.Results;
using Domain.Entities;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Services;

public class SeguridadService : ISeguridadService
{
    private readonly ISeguridadRepository _repo;

    public SeguridadService(ISeguridadRepository repo)
    {
        _repo = repo;
    }

    public async Task<ApiResponse<UsuarioDto>> RegistrarAsync(RegisterUserRequest request)
    {
        // Aquí luego puedes meter validaciones de negocio
        // 2️⃣ Crear entidad de dominio
        var usuario = new Usuario(
            0,
            request.Username
        );

        return await _repo.RegistrarAsync(request);
    }

    public async Task<ApiResponse<LoginDbDto>> LoginAsync(LoginRequest request)
    {
        return await _repo.LoginAsync(request);
    }
}