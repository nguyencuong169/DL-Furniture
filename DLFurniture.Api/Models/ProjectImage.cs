using System.Text.Json.Serialization;

namespace DLFurniture.Api.Models;

public class ProjectImage
{
    public long Id { get; set; }
    public long ProjectId { get; set; }
    public required string ImageUrl { get; set; }
    public string? Caption { get; set; }
    public int SortOrder { get; set; } = 0;
    public DateTimeOffset CreatedAt { get; set; }

    [JsonIgnore]
    public Project? Project { get; set; }
}