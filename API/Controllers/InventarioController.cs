using Application.DTOs;
using Application.Interface;
using Application.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers;

[ApiController]
[Route("api/inventario")]
[Authorize] // 🔐 TODO INVENTARIO REQUIERE TOKEN
public class InventarioController : ControllerBase
{
    private readonly IInventarioService _service;

    public InventarioController(IInventarioService service)
    {
        _service = service;
    }

    [HttpPost("producto")]
    public async Task<IActionResult> CrearProducto([FromBody] CrearProductoRequest req)
    {
        var result = await _service.CrearProductoAsync(req);
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
        var result = await _service.EntradaAsync(req);
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
        var result = await _service.SalidaAsync(req);
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
        var result = await _service.ListarProductosAsync();
        return result.Status switch
        {
            "SUCCESS" => Ok(result),
            "INFO" => Conflict(result),
            "ERROR" => StatusCode(500, result),
            _ => StatusCode(500, result)
        };
    }



}
