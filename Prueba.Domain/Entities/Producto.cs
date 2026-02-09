using System;
using System.Collections.Generic;
using System.Text;

namespace Domain.Entities
{
    public class Producto
    {
        public int ProductoId { get; set; }
        public string Codigo { get; set; } = string.Empty;
        public string Nombre { get; set; } = string.Empty;

        public Producto(int productoId, string codigo, string nombre)
        {
            ProductoId = productoId;
            Codigo = codigo;
            Nombre = nombre;
        }
    }
}
