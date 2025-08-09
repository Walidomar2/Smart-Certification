
using Microsoft.EntityFrameworkCore;
using Scalar.AspNetCore;
using SmartCertify.Infrastructure;

namespace SmartCertify.API
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.

            builder.Services.AddDbContext<SmartCertifyContext>(options =>
                options.UseSqlServer(builder.Configuration.GetConnectionString("SmartCertifyDatabase"),
                    providerOptions => providerOptions.EnableRetryOnFailure()));

            builder.Services.AddControllers();
            // Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
            builder.Services.AddOpenApi();

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.MapOpenApi();

                app.MapScalarApiReference(options =>
                {
                    options.Title = "SmartCertify API Reference";
                    options.Theme = ScalarTheme.DeepSpace;
                    options.WithSidebar(true);
                });
            }

            app.UseHttpsRedirection();

            app.UseAuthorization();


            app.MapControllers();

            app.Run();
        }
    }
}
