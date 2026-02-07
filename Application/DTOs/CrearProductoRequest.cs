using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs;

public record CrearProductoRequest(
    string Codigo,
    string Nombre,
    string Usuario
);