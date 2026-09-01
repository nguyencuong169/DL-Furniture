using DLFurniture.Api.Data;
using DLFurniture.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace DLFurniture.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class MenusController : ControllerBase
{
    private readonly AppDbContext _context;

    public MenusController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<MenusResponse>> GetMenus([FromQuery] string location = "all")
    {
        IQueryable<Menu> query = _context.Menus
            .Where(m => !m.DelFlag && !m.Hidden && m.IsActive);

        if (location != "all")
        {
            query = query.Where(m => m.Location == location);
        }

        var flat = await query
            .OrderBy(m => m.Location)
            .ThenBy(m => m.SortOrder)
            .ThenBy(m => m.Id)
            .Select(m => new
            {
                m.Id,
                m.ParentId,
                m.Label,
                m.Url,
                m.Location,
                m.IsConsultation
            })
            .ToListAsync();

                var primary = BuildTree(flat.Where(x => x.Location == "primary").Cast<dynamic>().ToList());
        var footer = BuildTree(flat.Where(x => x.Location == "footer").Cast<dynamic>().ToList());

        var response = new MenusResponse
        {
            Primary = primary,
            Footer = footer,
            Consultation = flat
                .Where(x => x.IsConsultation && x.Location == "primary")
                .Select(x => new MenuItem
                {
                    Label = x.Label,
                    Url = x.Url,
                    Children = null
                })
                .FirstOrDefault()
        };

        return Ok(response);
    }

    private static List<MenuItem> BuildTree(List<dynamic> flat, long? parentId = null)
    {
        return flat
            .Where(x => (long?)x.ParentId == parentId)
            .Select(x => new MenuItem
            {
                Id = x.Id,
                Label = x.Label,
                Url = x.Url,
                Children = BuildTree(flat, x.Id)
            })
            .ToList();
    }
}

public class MenusResponse
{
    public List<MenuItem> Primary { get; set; } = [];
    public List<MenuItem> Footer { get; set; } = [];
    public MenuItem? Consultation { get; set; }
}

public class MenuItem
{
    public long Id { get; set; }
    public string Label { get; set; } = string.Empty;
    public string Url { get; set; } = string.Empty;
    public List<MenuItem>? Children { get; set; }
}