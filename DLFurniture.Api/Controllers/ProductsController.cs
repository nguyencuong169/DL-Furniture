using DLFurniture.Api.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace DLFurniture.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    private readonly AppDbContext _context;

    public ProductsController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    [ProducesResponseType<IEnumerable<ProductDto>>(StatusCodes.Status200OK)]
    public async Task<ActionResult<IEnumerable<ProductDto>>> GetAll(
        [FromQuery] string? category = null,
        [FromQuery] bool? featured = null)
    {
        var query = _context.Products
            .AsNoTracking()
            .Where(product => product.IsActive && !product.Hidden);

        var normalizedCategory = category?.Trim().ToLowerInvariant();
        if (!string.IsNullOrWhiteSpace(normalizedCategory) && normalizedCategory != "all")
        {
            query = query.Where(product => product.Category != null && product.Category.Slug == normalizedCategory);
        }

        if (featured == true)
        {
            query = query.Where(product => product.Category != null && product.Category.DisplayOrder <= 3);
        }

        var items = await query
            .OrderBy(product => product.Category != null ? product.Category.DisplayOrder : 0)
            .ThenByDescending(product => product.UpdatedAt)
            .ThenByDescending(product => product.Id)
            .Select(product => new ProductDto
            {
                Id = product.Id,
                CategoryId = product.CategoryId,
                CategoryName = product.Category != null ? product.Category.Name : null,
                CategorySlug = product.Category != null ? product.Category.Slug : null,
                Sku = product.Sku,
                Slug = product.Slug,
                Name = product.Name,
                Summary = product.Summary,
                Description = product.Description,
                Price = product.Price,
                Currency = product.Currency,
                MainImage = product.MainImage,
                Images = product.ProductImages
                    .OrderBy(image => image.SortOrder)
                    .Select(image => new ProductImageDto
                    {
                        Id = image.Id,
                        ImageUrl = image.ImageUrl,
                        Caption = image.Caption,
                        SortOrder = image.SortOrder
                    })
                    .ToList()
            })
            .ToListAsync();

        return Ok(items);
    }

    [HttpGet("categories")]
    [ProducesResponseType<IEnumerable<ProductCategoryDto>>(StatusCodes.Status200OK)]
    public async Task<ActionResult<IEnumerable<ProductCategoryDto>>> GetCategories()
    {
        var categories = await _context.Categories
            .AsNoTracking()
            .Where(category =>
                category.IsActive &&
                category.ParentId == null &&
                category.ImageUrl != null)
            .OrderBy(category => category.DisplayOrder)
            .ThenBy(category => category.Name)
            .Select(category => new ProductCategoryDto
            {
                Id = category.Id,
                Name = category.Name,
                Slug = category.Slug,
                Description = category.Description,
                ImageUrl = category.ImageUrl!,
                ImageAlt = category.ImageAlt ?? category.Name,
                DisplayOrder = category.DisplayOrder,
                ProductCount = category.Products.Count(product => product.IsActive && !product.Hidden)
            })
            .ToListAsync();

        return Ok(categories);
    }

    [HttpGet("{id:long}")]
    [ProducesResponseType<ProductDto>(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<ProductDto>> GetById(long id)
    {
        var item = await _context.Products
            .AsNoTracking()
            .Where(product => product.Id == id && product.IsActive && !product.Hidden)
            .Select(product => new ProductDto
            {
                Id = product.Id,
                CategoryId = product.CategoryId,
                CategoryName = product.Category != null ? product.Category.Name : null,
                CategorySlug = product.Category != null ? product.Category.Slug : null,
                Sku = product.Sku,
                Slug = product.Slug,
                Name = product.Name,
                Summary = product.Summary,
                Description = product.Description,
                Price = product.Price,
                Currency = product.Currency,
                MainImage = product.MainImage,
                Images = product.ProductImages
                    .OrderBy(image => image.SortOrder)
                    .Select(image => new ProductImageDto
                    {
                        Id = image.Id,
                        ImageUrl = image.ImageUrl,
                        Caption = image.Caption,
                        SortOrder = image.SortOrder
                    })
                    .ToList()
            })
            .FirstOrDefaultAsync();

        return item is null ? NotFound() : Ok(item);
    }
}

public sealed class ProductDto
{
    public required long Id { get; init; }
    public long? CategoryId { get; init; }
    public string? CategoryName { get; init; }
    public string? CategorySlug { get; init; }
    public string? Sku { get; init; }
    public required string Slug { get; init; }
    public required string Name { get; init; }
    public string? Summary { get; init; }
    public string? Description { get; init; }
    public decimal? Price { get; init; }
    public string Currency { get; init; } = "VND";
    public string? MainImage { get; init; }
    public required IReadOnlyCollection<ProductImageDto> Images { get; init; }
}

public sealed class ProductImageDto
{
    public required long Id { get; init; }
    public required string ImageUrl { get; init; }
    public string? Caption { get; init; }
    public int SortOrder { get; init; }
}

public sealed class ProductCategoryDto
{
    public required long Id { get; init; }
    public required string Name { get; init; }
    public required string Slug { get; init; }
    public string? Description { get; init; }
    public required string ImageUrl { get; init; }
    public required string ImageAlt { get; init; }
    public int DisplayOrder { get; init; }
    public int ProductCount { get; init; }
}
