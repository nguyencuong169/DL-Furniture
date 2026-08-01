namespace DLFurniture.Api.Models;

public class BookingRequest
{
    public long Id { get; set; }
    public required string FullName { get; set; }
    public required string Email { get; set; }
    public string? Phone { get; set; }
    public string? Message { get; set; }
    public string Source { get; set; } = "consultation_form";
    public string Status { get; set; } = "pending";
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}
