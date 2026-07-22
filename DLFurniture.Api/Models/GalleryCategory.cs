using System.Text.Json.Serialization;

namespace DLFurniture.Api.Models;

public class GalleryCategory
{
    public long Id { get; set; }
    public required string Name { get; set; }
    public required string Slug { get; set; }
    public int DisplayOrder { get; set; }
    public bool IsActive { get; set; } = true;

    [JsonIgnore]
    public ICollection<GalleryItem> GalleryItems { get; set; } = new List<GalleryItem>();
}
