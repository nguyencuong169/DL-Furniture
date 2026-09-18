using DLFurniture.Api.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace DLFurniture.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ProjectsController : ControllerBase
{
    private readonly AppDbContext _context;

    public ProjectsController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    [ProducesResponseType<IEnumerable<ProjectDto>>(StatusCodes.Status200OK)]
    public async Task<ActionResult<IEnumerable<ProjectDto>>> GetProjects()
    {
        var projects = await _context.Projects
            .AsNoTracking()
            .Where(project => project.Status == "published")
            .OrderBy(project => project.Id)
            .Select(project => new ProjectDto
            {
                Id = project.Id,
                Title = project.Title,
                Subtitle = project.Subtitle,
                ClientName = project.ClientName,
                Location = project.Location,
                Description = project.Description,
                CoverImage = project.CoverImage,
                Status = project.Status,
                CreatedAt = project.CreatedAt,
                UpdatedAt = project.UpdatedAt,
                Images = project.ProjectImages
                    .OrderBy(image => image.SortOrder)
                    .ThenBy(image => image.Id)
                    .Select(image => new ProjectImageDto
                    {
                        Id = image.Id,
                        ImageUrl = image.ImageUrl,
                        Caption = image.Caption,
                        SortOrder = image.SortOrder
                    })
                    .ToList()
            })
            .ToListAsync();

        return Ok(projects);
    }

    [HttpGet("{id:long}")]
    [ProducesResponseType<ProjectDto>(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<ProjectDto>> GetById(long id)
    {
        var project = await _context.Projects
            .AsNoTracking()
            .Where(item => item.Id == id && item.Status == "published")
            .Select(item => new ProjectDto
            {
                Id = item.Id,
                Title = item.Title,
                Subtitle = item.Subtitle,
                ClientName = item.ClientName,
                Location = item.Location,
                Description = item.Description,
                CoverImage = item.CoverImage,
                Status = item.Status,
                CreatedAt = item.CreatedAt,
                UpdatedAt = item.UpdatedAt,
                Images = item.ProjectImages
                    .OrderBy(image => image.SortOrder)
                    .ThenBy(image => image.Id)
                    .Select(image => new ProjectImageDto
                    {
                        Id = image.Id,
                        ImageUrl = image.ImageUrl,
                        Caption = image.Caption,
                        SortOrder = image.SortOrder
                    })
                    .ToList()
            })
            .FirstOrDefaultAsync();

        return project is null ? NotFound() : Ok(project);
    }
}

public sealed class ProjectDto
{
    public required long Id { get; init; }
    public required string Title { get; init; }
    public string? Subtitle { get; init; }
    public string? ClientName { get; init; }
    public string? Location { get; init; }
    public string? Description { get; init; }
    public string? CoverImage { get; init; }
    public required string Status { get; init; }
    public DateTimeOffset CreatedAt { get; init; }
    public DateTimeOffset UpdatedAt { get; init; }
    public required IReadOnlyCollection<ProjectImageDto> Images { get; init; }
}

public sealed class ProjectImageDto
{
    public required long Id { get; init; }
    public required string ImageUrl { get; init; }
    public string? Caption { get; init; }
    public int SortOrder { get; init; }
}