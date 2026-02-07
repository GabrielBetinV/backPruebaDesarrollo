using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs;

public class LoginDbDto
{
    public int Usuario_Id { get; set; }
    public string Username { get; set; }
    public string PasswordHash { get; set; }
}
