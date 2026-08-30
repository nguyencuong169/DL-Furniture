using Microsoft.AspNetCore.Mvc;

namespace DLFurniture.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class StatsController : ControllerBase
{
    [HttpGet]
    public ActionResult<IEnumerable<StatResponse>> GetStats()
    {
        var stats = new List<StatResponse>
        {
            new() { Id = "experience", Value = 15 },
            new() { Id = "projects", Value = 320 },
            new() { Id = "area", Value = 12000 },
            new() { Id = "satisfaction", Value = 98 }
        };

        return Ok(stats);
    }

    public class StatResponse
    {
        public string Id { get; set; } = string.Empty;
        public int Value { get; set; }
    }
}
