using System.Text.Json.Serialization;

namespace DLFurniture.Api.Models;

public class Category
{
    public long Id { get; set; }
    public required string Name { get; set; }
    public required string Slug { get; set; }
    public long? ParentId { get; set; }
    public string? Description { get; set; }
    public string? ImageUrl { get; set; }
    public string? ImageAlt { get; set; }
    public int DisplayOrder { get; set; } = 0;
    public bool IsActive { get; set; } = true;
    public DateTimeOffset CreatedAt { get; set; }
    public DateTimeOffset UpdatedAt { get; set; }

    [JsonIgnore]
    public ICollection<Product> Products { get; set; } = new List<Product>();
}
