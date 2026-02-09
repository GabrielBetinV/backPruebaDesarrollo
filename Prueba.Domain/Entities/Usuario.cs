using System;
using System.Collections.Generic;
using System.Text;

namespace Domain.Entities
{
    public class Usuario
    {
        public int UsuarioId { get; set; }
        public string Username { get; set; } = string.Empty;


        public Usuario(int usuarioId, string username)
        {
            UsuarioId = usuarioId;
            Username = username;
        }
    }
}
