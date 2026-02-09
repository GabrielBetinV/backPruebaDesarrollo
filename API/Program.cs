//using API.Security;
//using Application.Interface;
//using Infrastructure.OracleDB.Dapper;
//using Infrastructure.OracleDB.SP;
//using Microsoft.AspNetCore.Authentication.JwtBearer;
//using Microsoft.IdentityModel.Tokens;
//using Microsoft.OpenApi.Models;
//using Oracle.ManagedDataAccess.Client;
//using System.Text;

//var builder = WebApplication.CreateBuilder(args);

//var oracleConnectionString =
//    builder.Configuration.GetConnectionString("Oracle");

//// Controllers + Swagger
//builder.Services.AddControllers();


//builder.Services.AddCors(options =>
//{
//    options.AddPolicy("AllowAngular",
//        policy =>
//        {
//            policy
//                .WithOrigins("http://localhost:4200")
//                .AllowAnyHeader()
//                .AllowAnyMethod();
//        });
//});

//builder.Services.AddEndpointsApiExplorer();

//builder.Services.AddSwaggerGen(options =>
//{
//    options.SwaggerDoc("v1", new OpenApiInfo
//    {
//        Title = "Inventario Enterprise API",
//        Version = "v1"
//    });

//    options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
//    {
//        Name = "Authorization",
//        Type = SecuritySchemeType.Http,
//        Scheme = "bearer",
//        BearerFormat = "JWT",
//        In = ParameterLocation.Header
//    });

//    options.AddSecurityRequirement(new OpenApiSecurityRequirement
//    {
//        {
//            new OpenApiSecurityScheme
//            {
//                Reference = new OpenApiReference
//                {
//                    Type = ReferenceType.SecurityScheme,
//                    Id = "Bearer"
//                }
//            },
//            Array.Empty<string>()
//        }
//    });
//});


//// 🔐 JWT
//var jwtConfig = builder.Configuration.GetSection("Jwt");
//var jwtKey = Encoding.UTF8.GetBytes(jwtConfig["Key"]!);

//builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
//.AddJwtBearer(options =>
//{
//    options.TokenValidationParameters = new TokenValidationParameters
//    {
//        ValidateIssuer = true,
//        ValidateAudience = true,
//        ValidateLifetime = true,
//        ValidateIssuerSigningKey = true,
//        ValidIssuer = jwtConfig["Issuer"],
//        ValidAudience = jwtConfig["Audience"],
//        IssuerSigningKey = new SymmetricSecurityKey(jwtKey)
//    };
//});

//// Services comunes
//builder.Services.AddScoped<JwtTokenService>();

//var dataAccessMode =
//    builder.Configuration["DataAccess:Mode"]?.ToUpper();



//// 🔀 SELECCIÓN DE ESTRATEGIA
//if (dataAccessMode == "DAPPER")
//{
//    // 🔹 DAPPER
//    builder.Services.AddSingleton(
//        new OracleConnectionFactory(oracleConnectionString));

//    builder.Services.AddScoped<ISeguridadRepository, SeguridadDapperRepository>();
//    builder.Services.AddScoped<IInventarioRepository, InventarioDapperRepository>();
//}
//else
//{
//    // 🔹 STORED PROCEDURES (DEFAULT)
//    builder.Services.AddScoped(_ =>
//    {
//        var conn = new OracleConnection(oracleConnectionString);
//        conn.Open();
//        return conn;
//    });

//    builder.Services.AddScoped<ISeguridadRepository, SeguridadSpRepository>();
//    builder.Services.AddScoped<IInventarioRepository, InventarioSpRepository>();
//}






//var app = builder.Build();

//app.UseSwagger();
//app.UseSwaggerUI();

//app.UseCors("AllowAngular");

//app.UseAuthentication();
//app.UseAuthorization();

//app.MapControllers();
//app.Run();


using API.Security;
using Application.Interface;
using Application.Services;
using Infrastructure.OracleDB.Dapper;
using Infrastructure.OracleDB.SP;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using Oracle.ManagedDataAccess.Client;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// ===============================
// 🔧 ORACLE
// ===============================
var oracleConnectionString =
    builder.Configuration.GetConnectionString("Oracle");

// ===============================
// 🔧 CONTROLLERS
// ===============================
builder.Services.AddControllers();

// ===============================
// 🌐 CORS
// ===============================
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAngular", policy =>
    {
        policy
            .WithOrigins("http://localhost:4200")
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});

// ===============================
// 📘 SWAGGER + JWT
// ===============================
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "Inventario Enterprise API",
        Version = "v1"
    });

    options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        Scheme = "bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
        Description = "Ingrese el token como: Bearer {token}"
    });

    options.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            Array.Empty<string>()
        }
    });
});

// ===============================
// 🔐 JWT CONFIGURACIÓN REAL
// ===============================
var jwtConfig = builder.Configuration.GetSection("Jwt");

var jwtKey = jwtConfig["Key"];
if (string.IsNullOrWhiteSpace(jwtKey) || jwtKey.Length < 32)
{
    throw new Exception("❌ JWT Key inválida (mínimo 32 caracteres)");
}

builder.Services
    .AddAuthentication(options =>
    {
        options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
    })
    .AddJwtBearer(options =>
    {
        options.RequireHttpsMetadata = false;
        options.SaveToken = true;

        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,

            ValidIssuer = jwtConfig["Issuer"],
            ValidAudience = jwtConfig["Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(jwtKey)
            ),

            ClockSkew = TimeSpan.Zero
        };

        options.Events = new JwtBearerEvents
        {
            OnMessageReceived = context =>
            {
                var authHeader = context.Request.Headers["Authorization"].FirstOrDefault();

                Console.WriteLine($"🔍 AUTH HEADER RAW: [{authHeader}]");

                if (!string.IsNullOrWhiteSpace(authHeader) &&
                    authHeader.StartsWith("Bearer ", StringComparison.OrdinalIgnoreCase))
                {
                    // 🧼 LIMPIEZA CRÍTICA
                    var token = authHeader
                        .Replace("Bearer ", "", StringComparison.OrdinalIgnoreCase)
                        .Trim();

                    context.Token = token;

                    Console.WriteLine($"✅ TOKEN LIMPIO: [{token}]");
                }

                return Task.CompletedTask;
            },

            OnAuthenticationFailed = context =>
            {
                Console.WriteLine("❌ JWT AUTH FAILED");
                Console.WriteLine(context.Exception.ToString());
                return Task.CompletedTask;
            }
        };
    });


builder.Services.AddAuthorization();

// ===============================
// 🔐 SERVICIOS
// ===============================
builder.Services.AddScoped<JwtTokenService>();

builder.Services.AddScoped<IInventarioService, InventarioService>();
builder.Services.AddScoped<ISeguridadService, SeguridadService>();


// ===============================
// 🔀 DATA ACCESS STRATEGY
// ===============================
var dataAccessMode =
    builder.Configuration["DataAccess:Mode"]?.ToUpper();

if (dataAccessMode == "DAPPER")
{
    // 🔹 DAPPER
    builder.Services.AddSingleton(
        new OracleConnectionFactory(oracleConnectionString));

    builder.Services.AddScoped<ISeguridadRepository, SeguridadDapperRepository>();
    builder.Services.AddScoped<IInventarioRepository, InventarioDapperRepository>();
}
else
{
    // 🔹 STORED PROCEDURES (DEFAULT)
    builder.Services.AddScoped(_ =>
    {
        var conn = new OracleConnection(oracleConnectionString);
        conn.Open();
        return conn;
    });

    builder.Services.AddScoped<ISeguridadRepository, SeguridadSpRepository>();
    builder.Services.AddScoped<IInventarioRepository, InventarioSpRepository>();
}

// ===============================
// 🚀 PIPELINE
// ===============================
var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.UseCors("AllowAngular");

app.UseAuthentication(); // ⬅️ NUNCA después de Authorization
app.UseAuthorization();

app.MapControllers();
app.Run();
