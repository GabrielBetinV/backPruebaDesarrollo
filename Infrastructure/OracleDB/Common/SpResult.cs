using System;
using System.Collections.Generic;
using System.Text;

namespace Infrastructure.OracleDB.Common;

public class SpResult
{
    public int Codigo { get; set; }
    public string Mensaje { get; set; } = string.Empty;
    public object? Data { get; set; }
}