using System.Text.Json.Serialization;

namespace DLFurniture.Api.Models;

public class Project
{
    public long Id { get; set; }
    public required string Title { get; set; }
    public string? Subtitle { get; set; }
    public string? ClientName { get; set; }
    public string? Location { get; set; }
    public long? CategoryId { get; set; }
    public string? Description { get; set; }
    public string? CoverImage { get; set; }
    public string Status { get; set; } = "published";
    public DateTimeOffset CreatedAt { get; set; }
    public DateTimeOffset UpdatedAt { get; set; }

    [JsonIgnore]
    public ICollection<GalleryItem> GalleryItems { get; set; } = new List<GalleryItem>();

    [JsonIgnore]
    public ICollection<ProjectImage> ProjectImages { get; set; } = new List<ProjectImage>();
}