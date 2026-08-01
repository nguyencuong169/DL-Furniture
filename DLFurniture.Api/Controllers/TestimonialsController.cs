using DLFurniture.Api.Data;
using DLFurniture.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace DLFurniture.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class TestimonialsController : ControllerBase
{
    private readonly AppDbContext _context;

    public TestimonialsController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Testimonial>>> GetAll()
    {
        var items = await _context.Testimonials
            .Where(x => !x.DelFlag && !x.Hidden)
            .OrderBy(x => x.SortOrder)
            .ThenByDescending(x => x.CreatedDate)
            .ToListAsync();

        return Ok(items);
    }

    [HttpGet("{id:long}")]
    public async Task<ActionResult<Testimonial>> GetById(long id)
    {
        var item = await _context.Testimonials
            .FirstOrDefaultAsync(x => x.Id == id && !x.DelFlag && !x.Hidden);
        return item is null ? NotFound() : Ok(item);
    }

    [HttpPost]
    public async Task<ActionResult<Testimonial>> Create([FromBody] Testimonial model)
    {
        model.CreatedDate ??= DateTimeOffset.UtcNow;
        model.UpdatedDate ??= model.CreatedDate;
        model.CreatedUser ??= "admin";
        model.UpdatedUser ??= "admin";

        _context.Testimonials.Add(model);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetById), new { id = model.Id }, model);
    }

    [HttpPut("{id:long}")]
    public async Task<ActionResult<Testimonial>> Update(long id, [FromBody] Testimonial model)
    {
        var existing = await _context.Testimonials.FindAsync(id);
        if (existing is null) return NotFound();

        existing.CustomerName = model.CustomerName;
        existing.Location = model.Location;
        existing.Content = model.Content;
        existing.AvatarImage = model.AvatarImage;
        existing.Rating = model.Rating;
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
        var existing = await _context.Testimonials.FindAsync(id);
        if (existing is null) return NotFound();

        existing.DelFlag = true;
        existing.UpdatedDate = DateTimeOffset.UtcNow;
        await _context.SaveChangesAsync();

        return NoContent();
    }
}
