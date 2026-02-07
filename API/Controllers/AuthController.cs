using API.Security;
using Application.DTOs;
using Application.Interface;
using Application.Results;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers;

[ApiController]
[Route("api/auth")]
[AllowAnonymous] // 👈 LOGIN Y REGISTRO NO REQUIEREN TOKEN
public class AuthController : ControllerBase
{
    private readonly ISeguridadRepository _repo;
    private readonly JwtTokenService _jwt;

    public AuthController(
        ISeguridadRepository repo,
        JwtTokenService jwt)
    {
        _repo = repo;
        _jwt = jwt;
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegisterUserRequest req)
    {
        ApiResponse<UsuarioDto> result = await _repo.RegistrarAsync(req);

        return result.Status switch
        {
            "SUCCESS" => Ok(result),
            "INFO" => Conflict(result),
            "ERROR" => StatusCode(500, result),
            _ => StatusCode(500, result)
        };
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login(LoginRequest req)
    {
        var result = await _repo.LoginAsync(req);

        if (result.Status != "SUCCESS")
            return Unauthorized(new ApiResponse<EmptyDto>(
                "INFO",
                "Credenciales inválidas",
                Array.Empty<EmptyDto>()
            ));

        var user = result.Data.First();

        if (!BCrypt.Net.BCrypt.Verify(req.Password, user.PasswordHash))
            return Unauthorized(new ApiResponse<EmptyDto>(
                "INFO",
                "Credenciales inválidas",
                Array.Empty<EmptyDto>()
            ));

        var token = _jwt.GenerateToken(user.Username);

        return Ok(new ApiResponse<object>(
            "SUCCESS",
            "Login correcto",
            new[]
            {
            new
            {
                token,
                usuario = user.Username
            }
            }
        ));
    }

}
