using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs;

public record MovimientoRequest(
    int ProductoId,
    int Cantidad,
    string Usuario
);