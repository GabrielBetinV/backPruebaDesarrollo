using Application.DTOs;
using Application.Interface;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers;

[ApiController]
[Route("api/inventario")]
//[Authorize] // 🔐 TODO INVENTARIO REQUIERE TOKEN
public class InventarioController : ControllerBase
{
    private readonly IInventarioRepository _repo;

    public InventarioController(IInventarioRepository repo)
    {
        _repo = repo;
    }

    [HttpPost("producto")]
    public async Task<IActionResult> CrearProducto([FromBody] CrearProductoRequest req)
    {
        var result = await _repo.CrearProductoAsync(req);
        return result.Status switch
        {
            "SUCCESS" => Ok(result),
            "INFO" => Conflict(result),
            "ERROR" => StatusCode(500, result),
            _ => StatusCode(500, result)
        };
    }

    [HttpPost("entrada")]
    public async Task<IActionResult> Entrada([FromBody] MovimientoRequest req)
    {
        var result = await _repo.EntradaAsync(req);
        return result.Status switch
        {
            "SUCCESS" => Ok(result),
            "INFO" => Conflict(result),
            "ERROR" => StatusCode(500, result),
            _ => StatusCode(500, result)
        };
    }

    [HttpPost("salida")]
    public async Task<IActionResult> Salida([FromBody] MovimientoRequest req)
    {
        var result = await _repo.SalidaAsync(req);
        return result.Status switch
        {
            "SUCCESS" => Ok(result),
            "INFO" => Conflict(result),
            "ERROR" => StatusCode(500, result),
            _ => StatusCode(500, result)
        };
    }



    [HttpGet("productos")]
    public async Task<IActionResult> ListarProductos()
    {
        var result = await _repo.ListarProductosAsync();
        return result.Status switch
        {
            "SUCCESS" => Ok(result),
            "INFO" => Conflict(result),
            "ERROR" => StatusCode(500, result),
            _ => StatusCode(500, result)
        };
    }



}
