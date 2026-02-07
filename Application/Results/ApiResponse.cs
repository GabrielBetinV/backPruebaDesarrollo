using System;
using System.Collections.Generic;
using System.Text;

namespace Application.Results;

public record ApiResponse<T>(
     string Status,
    string Message,
    IReadOnlyList<T> Data
);
