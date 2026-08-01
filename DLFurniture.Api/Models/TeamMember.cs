namespace DLFurniture.Api.Models;

public class TeamMember
{
    public long Id { get; set; }
    public string FullName { get; set; } = string.Empty;
    public string Role { get; set; } = string.Empty;
    public string? AvatarImage { get; set; }
    public string Email { get; set; } = string.Empty;
    public string? FacebookUrl { get; set; }
    public string? TwitterUrl { get; set; }
    public string? InstagramUrl { get; set; }
    public string? PinterestUrl { get; set; }
    public int SortOrder { get; set; } = 0;
    public bool Hidden { get; set; } = false;
    public bool DelFlag { get; set; } = false;
    public string? CreatedUser { get; set; }
    public DateTimeOffset? CreatedDate { get; set; }
    public string? UpdatedUser { get; set; }
    public DateTimeOffset? UpdatedDate { get; set; }
}

