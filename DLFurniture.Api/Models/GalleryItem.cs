using System.Text.Json.Serialization;

namespace DLFurniture.Api.Models;

public class GalleryItem
{
    public long Id { get; set; }
    public long CategoryId { get; set; }
    public long? ProjectId { get; set; }
    public required string Title { get; set; }
    public string? Description { get; set; }
    public required string MediaType { get; set; }
    public required string MediaUrl { get; set; }
    public string? ThumbnailUrl { get; set; }
    public string? AltText { get; set; }
    public string Provider { get; set; } = "local";
    public string? Duration { get; set; }
    public bool IsFeatured { get; set; }
    public int DisplayOrder { get; set; }
    public bool IsActive { get; set; } = true;
    public DateTimeOffset CreatedAt { get; set; }
    public DateTimeOffset UpdatedAt { get; set; }

    [JsonIgnore]
    public GalleryCategory Category { get; set; } = null!;

    [JsonIgnore]
    public Project? Project { get; set; }
}
