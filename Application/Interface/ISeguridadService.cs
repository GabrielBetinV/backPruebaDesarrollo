using Application.DTOs;
using Application.Results;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface;

public interface ISeguridadService
{
    Task<ApiResponse<UsuarioDto>> RegistrarAsync(RegisterUserRequest request);
    Task<ApiResponse<LoginDbDto>> LoginAsync(LoginRequest request);
}