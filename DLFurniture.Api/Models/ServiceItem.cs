namespace DLFurniture.Api.Models;

public class ServiceItem
{
    public long Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string? Image { get; set; }
    public string? Category { get; set; }
    public int SortOrder { get; set; } = 0;
    public bool Hidden { get; set; } = false;
    public bool DelFlag { get; set; } = false;
    public string? CreatedUser { get; set; }
    public DateTimeOffset? CreatedDate { get; set; }
    public string? UpdatedUser { get; set; }
    public DateTimeOffset? UpdatedDate { get; set; }
}

