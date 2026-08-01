using DLFurniture.Api.Data;
using DLFurniture.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace DLFurniture.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ServicesController : ControllerBase
{
    private readonly AppDbContext _context;

    public ServicesController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<ServiceItem>>> GetAll()
    {
        var items = await _context.Services
            .Where(x => !x.DelFlag && !x.Hidden)
            .OrderBy(x => x.SortOrder)
            .ThenByDescending(x => x.CreatedDate)
            .ToListAsync();

        return Ok(items);
    }

    [HttpGet("{id:long}")]
    public async Task<ActionResult<ServiceItem>> GetById(long id)
    {
        var item = await _context.Services
            .FirstOrDefaultAsync(x => x.Id == id && !x.DelFlag && !x.Hidden);
        return item is null ? NotFound() : Ok(item);
    }

    [HttpPost]
    public async Task<ActionResult<ServiceItem>> Create([FromBody] ServiceItem model)
    {
        model.CreatedDate ??= DateTimeOffset.UtcNow;
        model.UpdatedDate ??= model.CreatedDate;
        model.CreatedUser ??= "admin";
        model.UpdatedUser ??= "admin";

        _context.Services.Add(model);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetById), new { id = model.Id }, model);
    }

    [HttpPut("{id:long}")]
    public async Task<ActionResult<ServiceItem>> Update(long id, [FromBody] ServiceItem model)
    {
        var existing = await _context.Services.FindAsync(id);
        if (existing is null) return NotFound();

        existing.Name = model.Name;
        existing.Description = model.Description;
        existing.Image = model.Image;
        existing.Category = model.Category;
        existing.SortOrder = model.SortOrder;
        existing.Hidden = model.Hidden;
        existing.DelFlag = model.DelFlag;
        existing.UpdatedUser = model.UpdatedUser ?? "admin";
        existing.UpdatedDate = DateTimeOffset.UtcNow;

        await _context.SaveChangesAsync();
        return Ok(existing);
    }

    [HttpDelete("{id:long}")]
    public async Task<IActionResult> Delete(long id)
    {
        var existing = await _context.Services.FindAsync(id);
        if (existing is null) return NotFound();

        existing.DelFlag = true;
        existing.UpdatedDate = DateTimeOffset.UtcNow;
        await _context.SaveChangesAsync();

        return NoContent();
    }
}
