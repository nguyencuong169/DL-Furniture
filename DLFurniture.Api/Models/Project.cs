using System.Text.Json.Serialization;

namespace DLFurniture.Api.Models;

public class Project
{
    public long Id { get; set; }
    public required string Title { get; set; }

    [JsonIgnore]
    public ICollection<GalleryItem> GalleryItems { get; set; } = new List<GalleryItem>();
}
