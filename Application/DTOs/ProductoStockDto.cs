using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs;

public class ProductoStockDto
{
    public int ProductoId { get; set; }
    public string Codigo { get; set; }
    public string Nombre { get; set; }
    public int StockActual { get; set; }
}
