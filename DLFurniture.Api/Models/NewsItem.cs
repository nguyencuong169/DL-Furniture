using System.Text.Json.Serialization;

namespace DLFurniture.Api.Models;

public class NewsItem
{
    public long Id { get; set; }
    public string? NewsId { get; set; }
    public string? Titles { get; set; }
    public string? Summary { get; set; }
    public string? Content { get; set; }
    public string? NewsImage { get; set; }

    // Sidebar fields
    /// <summary>
    /// Category for NEWS (maps to news.news_category_id)
    /// </summary>
    public long? NewsCategoryId { get; set; }

    [JsonIgnore]
    public NewsCategory? NewsCategory { get; set; }

    /// <summary>
    /// Delimited by ',' e.g. "Restaurant,Hotel,Spa"
    /// </summary>
    public string? Tags { get; set; }


    public bool Hidden { get; set; }
    public bool DelFlag { get; set; }
    public string? CreatedUser { get; set; }
    public DateTimeOffset? CreatedDate { get; set; }
    public string? UpdatedUser { get; set; }
    public DateTimeOffset? UpdatedDate { get; set; }
}

