using System;
using System.Collections.Generic;
using System.Text;

namespace Application.DTOs;

public record LoginDbDto(
    int Usuario_Id,
    string Username,
    string PasswordHash
);
