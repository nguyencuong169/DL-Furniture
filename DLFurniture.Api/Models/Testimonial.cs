namespace DLFurniture.Api.Models;

public class Testimonial
{
    public long Id { get; set; }
    public string CustomerName { get; set; } = string.Empty;
    public string Location { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public string AvatarImage { get; set; } = string.Empty;
    public int Rating { get; set; } = 5;
    public int SortOrder { get; set; } = 0;
    public bool Hidden { get; set; } = false;
    public bool DelFlag { get; set; } = false;
    public string? CreatedUser { get; set; }
    public DateTimeOffset? CreatedDate { get; set; }
    public string? UpdatedUser { get; set; }
    public DateTimeOffset? UpdatedDate { get; set; }
}

