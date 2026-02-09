using Application.DTOs;
using Application.Interface;
using Application.Results;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Services;

public class InventarioService : IInventarioService
{
    private readonly IInventarioRepository _repo;

    public InventarioService(IInventarioRepository repo)
    {
        _repo = repo;
    }

    public async Task<ApiResponse<ProductoDto>> CrearProductoAsync(CrearProductoRequest request)
    {
        return await _repo.CrearProductoAsync(request);
    }

    public async Task<ApiResponse<EmptyDto>> EntradaAsync(MovimientoRequest request)
    {
        return await _repo.EntradaAsync(request);
    }

    public async Task<ApiResponse<EmptyDto>> SalidaAsync(MovimientoRequest request)
    {
        return await _repo.SalidaAsync(request);
    }

    public async Task<ApiResponse<ProductoStockDto>> ListarProductosAsync()
    {
        return await _repo.ListarProductosAsync();
    }
}