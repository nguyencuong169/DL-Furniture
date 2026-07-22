using DLFurniture.Api.Data;
using DLFurniture.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace DLFurniture.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class NewsController : ControllerBase
{
    private readonly AppDbContext _context;

    public NewsController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<NewsItem>>> GetAll()
    {
        // Keep the list payload explicit so it stays stable as the entity grows.
        var items = await _context.News
            .Where(x => !x.DelFlag && !x.Hidden)
            .OrderByDescending(x => x.UpdatedDate)
            .Select(x => new NewsItem
            {
                Id = x.Id,
                NewsId = x.NewsId,
                Titles = x.Titles,
                Summary = x.Summary,
                Content = x.Content,
                NewsImage = x.NewsImage,
                Hidden = x.Hidden,
                DelFlag = x.DelFlag,
                CreatedUser = x.CreatedUser,
                CreatedDate = x.CreatedDate,
                UpdatedUser = x.UpdatedUser,
                UpdatedDate = x.UpdatedDate,
                // Sidebar fields (may not exist in DB yet)
                NewsCategoryId = x.NewsCategoryId,
                Tags = x.Tags
            })
            .ToListAsync();

        return Ok(items);
    }


    public class CategoryDto
    {
        public required long Id { get; set; }
        public required string Name { get; set; }
        public required string Slug { get; set; }
        public required int PublishedCount { get; set; }
    }

    public class TagDto
    {
        public required string Name { get; set; }
        public required int Count { get; set; }
    }

    public class ArchiveDto
    {
        public required int Year { get; set; }
        public required int Month { get; set; }
        public required string MonthLabel { get; set; }
        public required int Count { get; set; }
    }

    [HttpGet("categories")]
    public async Task<ActionResult<IEnumerable<CategoryDto>>> GetCategories()
    {
        var items = await _context.NewsCategories
            .AsNoTracking()
            .Where(category => category.IsActive)
            .OrderBy(category => category.DisplayOrder)
            .ThenBy(category => category.Name)
            .Select(category => new CategoryDto
            {
                Id = category.Id,
                Name = category.Name,
                Slug = category.Slug,
                PublishedCount = category.NewsItems.Count(news => !news.DelFlag && !news.Hidden)
            })
            .ToListAsync();

        return Ok(items);
    }

    [HttpGet("tags")]
    public async Task<ActionResult<IEnumerable<TagDto>>> GetTags()
    {
        var items = await _context.News
            .Where(x => !x.DelFlag && !x.Hidden && x.Tags != null && x.Tags != "")
            .Select(x => x.Tags!)
            .ToListAsync();

        var dict = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
        foreach (var raw in items)
        {
            var parts = raw.Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);
            foreach (var p in parts)
            {
                if (!dict.ContainsKey(p)) dict[p] = 0;
                dict[p]++;
            }
        }

        return Ok(dict
            .Select(kvp => new TagDto { Name = kvp.Key, Count = kvp.Value })
            .OrderByDescending(x => x.Count)
            .ThenBy(x => x.Name)
            .Take(20)
            .ToList());
    }

    [HttpGet("archives")]
    public async Task<ActionResult<IEnumerable<ArchiveDto>>> GetArchives()
    {
        var grouped = await _context.News
            .Where(x => !x.DelFlag && !x.Hidden && x.UpdatedDate != null)
            .GroupBy(x => new { x.UpdatedDate!.Value.Year, x.UpdatedDate!.Value.Month })
            .Select(g => new
            {
                g.Key.Year,
                g.Key.Month,
                Count = g.Count()
            })
            .OrderByDescending(x => x.Year)
            .ThenByDescending(x => x.Month)
            .ToListAsync();

        var result = grouped.Select(g => new ArchiveDto
        {
            Year = g.Year,
            Month = g.Month,
            MonthLabel = new DateTime(g.Year, g.Month, 1).ToString("MMMM", System.Globalization.CultureInfo.GetCultureInfo("vi-VN")),
            Count = g.Count
        }).ToList();

        return Ok(result);
    }

    [HttpGet("{id:int}/related")]
    public async Task<ActionResult<IEnumerable<NewsItem>>> GetRelated(int id, [FromQuery] int take = 3)
    {
        var current = await _context.News.FirstOrDefaultAsync(x => x.Id == id && !x.DelFlag && !x.Hidden);
        if (current is null) return NotFound();

        var currentTags = (current.Tags ?? "")
            .Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
            .Select(x => x.ToLowerInvariant())
            .ToHashSet();

        take = Math.Clamp(take, 1, 12);

        var candidates = await _context.News
            .Where(x => x.Id != id && !x.DelFlag && !x.Hidden)
            .ToListAsync();

        static int TagOverlap(string? tags, HashSet<string> currentTags)
        {
            if (string.IsNullOrWhiteSpace(tags)) return 0;
            var parts = tags.Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);
            var overlap = 0;
            foreach (var p in parts)
            {
                if (currentTags.Contains(p.ToLowerInvariant())) overlap++;
            }
            return overlap;
        }

        var scored = candidates
            .Select(x => new
            {
                Item = x,
                CategoryMatch = current.NewsCategoryId.HasValue && x.NewsCategoryId == current.NewsCategoryId ? 1 : 0,

                TagOverlap = TagOverlap(x.Tags, currentTags)
            })
            .OrderByDescending(x => x.CategoryMatch)
            .ThenByDescending(x => x.TagOverlap)
            .ThenByDescending(x => x.Item.UpdatedDate)
            .Take(take)
            .Select(x => x.Item)
            .ToList();

        return Ok(scored);
    }


    public class PagedNewsResponse
    {
        public required IEnumerable<NewsItem> Items { get; set; }
        public required int TotalCount { get; set; }
        public required int Page { get; set; }
        public required int PageSize { get; set; }
        public required int TotalPages { get; set; }
    }

    [HttpGet("paged")]
    public async Task<ActionResult<PagedNewsResponse>> GetPaged(
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 6,
        [FromQuery] int? year = null,
        [FromQuery] int? month = null,
        [FromQuery] long? categoryId = null,
        [FromQuery] string? tag = null,
        [FromQuery] string? search = null)
    {
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = 6;
        pageSize = Math.Min(pageSize, 50);

        var query = _context.News
            .Where(x => !x.DelFlag && !x.Hidden)
            .AsQueryable();

        if (year.HasValue)
        {
            query = query.Where(x => x.UpdatedDate.HasValue && x.UpdatedDate.Value.Year == year.Value);
        }

        if (month.HasValue)
        {
            query = query.Where(x => x.UpdatedDate.HasValue && x.UpdatedDate.Value.Month == month.Value);
        }

        if (categoryId.HasValue)
        {
            query = query.Where(x => x.NewsCategoryId == categoryId.Value);
        }

        if (!string.IsNullOrWhiteSpace(tag))
        {
            var normalizedTag = tag.Trim();
            query = query.Where(x => x.Tags != null && ("," + x.Tags + ",").Contains("," + normalizedTag + ","));
        }

        if (!string.IsNullOrWhiteSpace(search))
        {
            var pattern = $"%{search.Trim()}%";
            query = query.Where(x =>
                (x.Titles != null && EF.Functions.Like(x.Titles, pattern)) ||
                (x.Summary != null && EF.Functions.Like(x.Summary, pattern)) ||
                (x.Content != null && EF.Functions.Like(x.Content, pattern)));
        }

        var totalCount = await query.CountAsync();
        var totalPages = (int)Math.Ceiling(totalCount / (double)pageSize);
        if (totalPages > 0 && page > totalPages) page = totalPages;

        var items = await query
            .OrderByDescending(x => x.UpdatedDate)
            .ThenByDescending(x => x.Id)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        return Ok(new PagedNewsResponse
        {
            Items = items,
            TotalCount = totalCount,
            Page = page,
            PageSize = pageSize,
            TotalPages = totalPages
        });
    }


    [HttpGet("{id:int}")]
    public async Task<ActionResult<NewsItem>> GetById(int id)
    {
        var item = await _context.News
            .FirstOrDefaultAsync(x => x.Id == id && !x.DelFlag && !x.Hidden);
        return item is null ? NotFound() : Ok(item);
    }

    [HttpPost]
    public async Task<ActionResult<NewsItem>> Create([FromBody] NewsItem model)
    {
        var categoryError = await ValidateCategoryAsync(model);
        if (categoryError is not null) return BadRequest(new { message = categoryError });

        model.CreatedDate ??= DateTimeOffset.UtcNow;
        model.UpdatedDate ??= model.CreatedDate;
        model.CreatedUser ??= "admin";
        model.UpdatedUser ??= "admin";

        _context.News.Add(model);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetById), new { id = model.Id }, model);
    }

    [HttpPut("{id:int}")]
    public async Task<ActionResult<NewsItem>> Update(int id, [FromBody] NewsItem model)
    {
        var existing = await _context.News.FindAsync(id);
        if (existing is null) return NotFound();

        var categoryError = await ValidateCategoryAsync(model);
        if (categoryError is not null) return BadRequest(new { message = categoryError });

        existing.Titles = model.Titles;
        existing.Summary = model.Summary;
        existing.Content = model.Content;
        existing.NewsImage = model.NewsImage;
        existing.NewsCategoryId = model.NewsCategoryId;
        existing.Tags = model.Tags;
        existing.Hidden = model.Hidden;
        existing.DelFlag = model.DelFlag;
        existing.UpdatedUser = model.UpdatedUser ?? "admin";
        existing.UpdatedDate = DateTimeOffset.UtcNow;

        await _context.SaveChangesAsync();
        return Ok(existing);
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        var existing = await _context.News.FindAsync(id);
        if (existing is null) return NotFound();

        existing.DelFlag = true;
        existing.UpdatedDate = DateTimeOffset.UtcNow;
        await _context.SaveChangesAsync();

        return NoContent();
    }

    private async Task<string?> ValidateCategoryAsync(NewsItem model)
    {
        if (!model.NewsCategoryId.HasValue)
        {
            return !model.Hidden && !model.DelFlag
                ? "Bài viết công khai phải thuộc một chuyên mục tin tức."
                : null;
        }

        var categoryIsActive = await _context.NewsCategories
            .AnyAsync(category => category.Id == model.NewsCategoryId.Value && category.IsActive);

        return categoryIsActive ? null : "Chuyên mục tin tức không tồn tại hoặc đã ngừng sử dụng.";
    }
}
