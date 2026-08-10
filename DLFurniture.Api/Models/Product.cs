using System.Text.Json.Serialization;

namespace DLFurniture.Api.Models;

public class Product
{
    public long Id { get; set; }
    public long? CategoryId { get; set; }
    public string? Sku { get; set; }
    public required string Slug { get; set; }
    public required string Name { get; set; }
    public string? Summary { get; set; }
    public string? Description { get; set; }
    public decimal? Price { get; set; }
    public string Currency { get; set; } = "VND";
    public string? MainImage { get; set; }
    public bool IsActive { get; set; } = true;
    public bool Hidden { get; set; } = false;
    public DateTimeOffset CreatedAt { get; set; }
    public DateTimeOffset UpdatedAt { get; set; }

    [JsonIgnore]
    public Category? Category { get; set; }

    [JsonIgnore]
    public ICollection<ProductImage> ProductImages { get; set; } = new List<ProductImage>();
}
