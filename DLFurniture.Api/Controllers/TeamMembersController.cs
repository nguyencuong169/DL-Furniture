using DLFurniture.Api.Data;
using DLFurniture.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace DLFurniture.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Route("api/team-members")]
public class TeamMembersController : ControllerBase
{
    private readonly AppDbContext _context;

    public TeamMembersController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<TeamMember>>> GetAll()
    {
        var items = await _context.TeamMembers
            .Where(x => !x.DelFlag && !x.Hidden)
            .OrderBy(x => x.SortOrder)
            .ThenByDescending(x => x.CreatedDate)
            .ToListAsync();

        return Ok(items);
    }

    [HttpGet("{id:long}")]
    public async Task<ActionResult<TeamMember>> GetById(long id)
    {
        var item = await _context.TeamMembers
            .FirstOrDefaultAsync(x => x.Id == id && !x.DelFlag && !x.Hidden);
        return item is null ? NotFound() : Ok(item);
    }

    [HttpPost]
    public async Task<ActionResult<TeamMember>> Create([FromBody] TeamMember model)
    {
        model.CreatedDate ??= DateTimeOffset.UtcNow;
        model.UpdatedDate ??= model.CreatedDate;
        model.CreatedUser ??= "admin";
        model.UpdatedUser ??= "admin";

        _context.TeamMembers.Add(model);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetById), new { id = model.Id }, model);
    }

    [HttpPut("{id:long}")]
    public async Task<ActionResult<TeamMember>> Update(long id, [FromBody] TeamMember model)
    {
        var existing = await _context.TeamMembers.FindAsync(id);
        if (existing is null) return NotFound();

        existing.FullName = model.FullName;
        existing.Role = model.Role;
        existing.AvatarImage = model.AvatarImage;
        existing.Email = model.Email;
        existing.FacebookUrl = model.FacebookUrl;
        existing.TwitterUrl = model.TwitterUrl;
        existing.InstagramUrl = model.InstagramUrl;
        existing.PinterestUrl = model.PinterestUrl;
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
        var existing = await _context.TeamMembers.FindAsync(id);
        if (existing is null) return NotFound();

        existing.DelFlag = true;
        existing.UpdatedDate = DateTimeOffset.UtcNow;
        await _context.SaveChangesAsync();

        return NoContent();
    }
}
