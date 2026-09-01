namespace DLFurniture.Api.Models;

public class Menu
{
    public long Id { get; set; }
    public long? ParentId { get; set; }
    public string Label { get; set; } = string.Empty;
    public string Url { get; set; } = string.Empty;
    public string Location { get; set; } = "primary";
    public int SortOrder { get; set; } = 0;
    public bool IsConsultation { get; set; }
    public bool IsActive { get; set; } = true;
    public bool Hidden { get; set; } = false;
    public bool DelFlag { get; set; } = false;
    public string? CreatedUser { get; set; }
    public DateTimeOffset? CreatedDate { get; set; }
    public string? UpdatedUser { get; set; }
    public DateTimeOffset? UpdatedDate { get; set; }
}