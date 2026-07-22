using DLFurniture.Api.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace DLFurniture.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class GalleryController : ControllerBase
{
    private static readonly HashSet<string> SupportedMediaTypes =
        new(StringComparer.OrdinalIgnoreCase) { "image", "video" };

    private readonly AppDbContext _context;

    public GalleryController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    [ProducesResponseType<GalleryResponseDto>(StatusCodes.Status200OK)]
    public async Task<ActionResult<GalleryResponseDto>> GetGallery(
        [FromQuery] string? type = null,
        [FromQuery] string? category = null,
        [FromQuery] string? search = null,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 9)
    {
        page = Math.Max(page, 1);
        pageSize = Math.Clamp(pageSize, 1, 24);

        var normalizedType = type?.Trim().ToLowerInvariant();
        if (normalizedType == "all") normalizedType = null;
        if (normalizedType is not null && !SupportedMediaTypes.Contains(normalizedType))
        {
            return BadRequest(new { message = "Loại nội dung phải là image hoặc video." });
        }

        var publishedItems = _context.GalleryItems
            .AsNoTracking()
            .Where(item => item.IsActive && item.Category.IsActive);

        var imageCount = await publishedItems.CountAsync(item => item.MediaType == "image");
        var videoCount = await publishedItems.CountAsync(item => item.MediaType == "video");

        var categories = await _context.GalleryCategories
            .AsNoTracking()
            .Where(item => item.IsActive)
            .OrderBy(item => item.DisplayOrder)
            .ThenBy(item => item.Name)
            .Select(item => new GalleryCategoryDto
            {
                Id = item.Id,
                Name = item.Name,
                Slug = item.Slug,
                ItemCount = item.GalleryItems.Count(media => media.IsActive)
            })
            .ToListAsync();

        var query = publishedItems;
        if (normalizedType is not null)
        {
            query = query.Where(item => item.MediaType == normalizedType);
        }

        var normalizedCategory = category?.Trim().ToLowerInvariant();
        if (!string.IsNullOrWhiteSpace(normalizedCategory) && normalizedCategory != "all")
        {
            query = query.Where(item => item.Category.Slug == normalizedCategory);
        }

        if (!string.IsNullOrWhiteSpace(search))
        {
            var pattern = $"%{search.Trim()}%";
            query = query.Where(item =>
                EF.Functions.Like(item.Title, pattern) ||
                (item.Description != null && EF.Functions.Like(item.Description, pattern)) ||
                (item.AltText != null && EF.Functions.Like(item.AltText, pattern)) ||
                (item.Project != null && EF.Functions.Like(item.Project.Title, pattern)));
        }

        var totalCount = await query.CountAsync();
        var totalPages = totalCount == 0 ? 0 : (int)Math.Ceiling(totalCount / (double)pageSize);
        if (totalPages > 0 && page > totalPages) page = totalPages;

        var items = await query
            .OrderByDescending(item => item.UpdatedAt)
            .ThenByDescending(item => item.Id)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(item => new GalleryItemDto
            {
                Id = item.Id,
                Title = item.Title,
                Description = item.Description,
                MediaType = item.MediaType,
                MediaUrl = item.MediaUrl,
                ThumbnailUrl = item.ThumbnailUrl,
                AltText = item.AltText,
                Provider = item.Provider,
                Duration = item.Duration,
                IsFeatured = item.IsFeatured,
                CategoryName = item.Category.Name,
                CategorySlug = item.Category.Slug,
                ProjectId = item.ProjectId,
                ProjectTitle = item.Project != null ? item.Project.Title : null
            })
            .ToListAsync();

        return Ok(new GalleryResponseDto
        {
            Items = items,
            Categories = categories,
            Counts = new GalleryCountsDto
            {
                All = imageCount + videoCount,
                Images = imageCount,
                Videos = videoCount
            },
            TotalCount = totalCount,
            Page = page,
            PageSize = pageSize,
            TotalPages = totalPages
        });
    }

    [HttpGet("{id:long}")]
    [ProducesResponseType<GalleryItemDto>(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<GalleryItemDto>> GetById(long id)
    {
        var item = await _context.GalleryItems
            .AsNoTracking()
            .Where(media => media.Id == id && media.IsActive && media.Category.IsActive)
            .Select(media => new GalleryItemDto
            {
                Id = media.Id,
                Title = media.Title,
                Description = media.Description,
                MediaType = media.MediaType,
                MediaUrl = media.MediaUrl,
                ThumbnailUrl = media.ThumbnailUrl,
                AltText = media.AltText,
                Provider = media.Provider,
                Duration = media.Duration,
                IsFeatured = media.IsFeatured,
                CategoryName = media.Category.Name,
                CategorySlug = media.Category.Slug,
                ProjectId = media.ProjectId,
                ProjectTitle = media.Project != null ? media.Project.Title : null
            })
            .FirstOrDefaultAsync();

        return item is null ? NotFound() : Ok(item);
    }
}

public sealed class GalleryResponseDto
{
    public required IReadOnlyCollection<GalleryItemDto> Items { get; init; }
    public required IReadOnlyCollection<GalleryCategoryDto> Categories { get; init; }
    public required GalleryCountsDto Counts { get; init; }
    public required int TotalCount { get; init; }
    public required int Page { get; init; }
    public required int PageSize { get; init; }
    public required int TotalPages { get; init; }
}

public sealed class GalleryItemDto
{
    public required long Id { get; init; }
    public required string Title { get; init; }
    public string? Description { get; init; }
    public required string MediaType { get; init; }
    public required string MediaUrl { get; init; }
    public string? ThumbnailUrl { get; init; }
    public string? AltText { get; init; }
    public required string Provider { get; init; }
    public string? Duration { get; init; }
    public required bool IsFeatured { get; init; }
    public required string CategoryName { get; init; }
    public required string CategorySlug { get; init; }
    public long? ProjectId { get; init; }
    public string? ProjectTitle { get; init; }
}

public sealed class GalleryCategoryDto
{
    public required long Id { get; init; }
    public required string Name { get; init; }
    public required string Slug { get; init; }
    public required int ItemCount { get; init; }
}

public sealed class GalleryCountsDto
{
    public required int All { get; init; }
    public required int Images { get; init; }
    public required int Videos { get; init; }
}
