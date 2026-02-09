using Application.DTOs;
using Application.Results;
using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Interface;

public interface IInventarioService
{
    Task<ApiResponse<ProductoDto>> CrearProductoAsync(CrearProductoRequest request);
    Task<ApiResponse<EmptyDto>> EntradaAsync(MovimientoRequest request);
    Task<ApiResponse<EmptyDto>> SalidaAsync(MovimientoRequest request);
    Task<ApiResponse<ProductoStockDto>> ListarProductosAsync();
}