using System.ComponentModel.DataAnnotations;
using System.Globalization;
using System.Text.RegularExpressions;
using DLFurniture.Api.Data;
using DLFurniture.Api.Models;
using Microsoft.AspNetCore.Mvc;

namespace DLFurniture.Api.Controllers;

[ApiController]
[Route("api/booking-requests")]
public partial class BookingRequestsController : ControllerBase
{
    private static readonly IReadOnlyDictionary<string, string> ServiceLabels =
        new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            ["design-build"] = "Thiết kế & thi công trọn gói",
            ["design"] = "Thiết kế nội thất",
            ["construction"] = "Thi công hoàn thiện",
            ["furniture"] = "Sản xuất nội thất"
        };

    private static readonly IReadOnlyDictionary<string, string> PropertyLabels =
        new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            ["apartment"] = "Căn hộ",
            ["townhouse"] = "Nhà phố",
            ["villa"] = "Biệt thự",
            ["office"] = "Văn phòng",
            ["hospitality"] = "Nhà hàng / khách sạn",
            ["other"] = "Công trình khác"
        };

    private static readonly IReadOnlyDictionary<string, string> BudgetLabels =
        new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            ["consult"] = "Cần tư vấn",
            ["under-500"] = "Dưới 500 triệu",
            ["500-1000"] = "500 triệu – 1 tỷ",
            ["1000-2000"] = "1 – 2 tỷ",
            ["over-2000"] = "Trên 2 tỷ"
        };

    private readonly AppDbContext _context;

    public BookingRequestsController(AppDbContext context)
    {
        _context = context;
    }

    [HttpPost]
    [ProducesResponseType<ConsultationResponse>(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<ConsultationResponse>> Create(
        [FromBody] CreateConsultationRequest request,
        CancellationToken cancellationToken)
    {
        if (!string.IsNullOrWhiteSpace(request.Website))
        {
            return StatusCode(StatusCodes.Status201Created, new ConsultationResponse
            {
                Message = "Yêu cầu tư vấn đã được tiếp nhận."
            });
        }

        var phone = NormalizePhone(request.Phone);
        if (!VietnamesePhoneRegex().IsMatch(phone))
        {
            ModelState.AddModelError(nameof(request.Phone), "Số điện thoại không hợp lệ.");
        }

        if (!ServiceLabels.TryGetValue(request.ServiceType, out var serviceLabel))
        {
            ModelState.AddModelError(nameof(request.ServiceType), "Vui lòng chọn dịch vụ cần tư vấn.");
        }

        if (!PropertyLabels.TryGetValue(request.PropertyType, out var propertyLabel))
        {
            ModelState.AddModelError(nameof(request.PropertyType), "Vui lòng chọn loại công trình.");
        }

        string? budgetLabel = null;
        if (!string.IsNullOrWhiteSpace(request.Budget) &&
            !BudgetLabels.TryGetValue(request.Budget, out budgetLabel))
        {
            ModelState.AddModelError(nameof(request.Budget), "Khoảng ngân sách không hợp lệ.");
        }

        if (!request.AcceptedPrivacy)
        {
            ModelState.AddModelError(
                nameof(request.AcceptedPrivacy),
                "Bạn cần đồng ý để D&L Furniture liên hệ tư vấn.");
        }

        if (!ModelState.IsValid)
        {
            return ValidationProblem(ModelState);
        }

        var details = new List<string>
        {
            $"Dịch vụ: {serviceLabel}",
            $"Loại công trình: {propertyLabel}"
        };

        if (request.EstimatedArea.HasValue)
        {
            details.Add(
                $"Diện tích dự kiến: {request.EstimatedArea.Value.ToString("0.##", CultureInfo.InvariantCulture)} m²");
        }

        if (!string.IsNullOrWhiteSpace(budgetLabel))
        {
            details.Add($"Ngân sách: {budgetLabel}");
        }

        if (!string.IsNullOrWhiteSpace(request.ProjectLocation))
        {
            details.Add($"Địa điểm: {request.ProjectLocation.Trim()}");
        }

        if (!string.IsNullOrWhiteSpace(request.Message))
        {
            details.Add($"Mong muốn: {request.Message.Trim()}");
        }

        if (!string.IsNullOrWhiteSpace(request.PagePath))
        {
            details.Add($"Trang gửi yêu cầu: {request.PagePath.Trim()}");
        }

        var now = DateTimeOffset.UtcNow;
        var bookingRequest = new BookingRequest
        {
            FullName = request.FullName.Trim(),
            Email = request.Email.Trim(),
            Phone = phone,
            Message = string.Join(Environment.NewLine, details),
            Source = "consultation_form",
            Status = "pending",
            CreatedAt = now,
            UpdatedAt = now
        };

        _context.BookingRequests.Add(bookingRequest);
        await _context.SaveChangesAsync(cancellationToken);

        return StatusCode(StatusCodes.Status201Created, new ConsultationResponse
        {
            Id = bookingRequest.Id,
            Message = "Cảm ơn bạn. D&L Furniture sẽ liên hệ tư vấn trong thời gian sớm nhất."
        });
    }

    private static string NormalizePhone(string phone)
    {
        var normalized = Regex.Replace(phone.Trim(), @"[\s().-]", string.Empty);
        return normalized.StartsWith("+84", StringComparison.Ordinal)
            ? $"84{normalized[3..]}"
            : normalized;
    }

    [GeneratedRegex(@"^(?:84\d{9}|0\d{9,10})$")]
    private static partial Regex VietnamesePhoneRegex();
}

public class CreateConsultationRequest
{
    [Required]
    [StringLength(255, MinimumLength = 2)]
    public string FullName { get; set; } = string.Empty;

    [Required]
    [EmailAddress]
    [StringLength(255)]
    public string Email { get; set; } = string.Empty;

    [Required]
    [StringLength(50)]
    public string Phone { get; set; } = string.Empty;

    [Required]
    [StringLength(50)]
    public string ServiceType { get; set; } = string.Empty;

    [Required]
    [StringLength(50)]
    public string PropertyType { get; set; } = string.Empty;

    [Range(typeof(decimal), "1", "100000")]
    public decimal? EstimatedArea { get; set; }

    [StringLength(50)]
    public string? Budget { get; set; }

    [StringLength(255)]
    public string? ProjectLocation { get; set; }

    [StringLength(4000)]
    public string? Message { get; set; }

    [StringLength(500)]
    public string? PagePath { get; set; }

    public bool AcceptedPrivacy { get; set; }

    [StringLength(255)]
    public string? Website { get; set; }
}

public class ConsultationResponse
{
    public long? Id { get; set; }
    public required string Message { get; set; }
}
