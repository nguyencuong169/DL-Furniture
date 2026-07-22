namespace DLFurniture.Api.Models;

public class NewsCategory
{
    public long Id { get; set; }
    public required string Name { get; set; }
    public required string Slug { get; set; }
    public int DisplayOrder { get; set; }
    public bool IsActive { get; set; } = true;

    public ICollection<NewsItem> NewsItems { get; set; } = new List<NewsItem>();
}
