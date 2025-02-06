using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using cms.Data;
using cms.Models;

[ApiController]
[Route("api/[controller]")]
public class SuppliersController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public SuppliersController(ApplicationDbContext context)
    {
        _context = context;
    }

    // GET: api/Suppliers
    [HttpGet]
    public IActionResult Get()
    {
        var suppliers = (from s in _context.Suppliers
                         select new
                         {
                             s.Id,
                             s.Name,
                             Products = s.Products.Select(p => new
                             {
                                 p.Id,
                                 p.Name
                             }).ToList()
                         }).ToList();
        return Ok(suppliers);
    }

    // GET: api/Suppliers/{id}
    [HttpGet("{id}")]
    public IActionResult Get(int id)
    {
        var supplier = (from s in _context.Suppliers
                        where s.Id == id
                        select new
                        {
                            s.Id,
                            s.Name,
                            Products = s.Products.Select(p => new
                            {
                                p.Id,
                                p.Name
                            }).ToList()
                        }).FirstOrDefault();

        if (supplier == null)
            return NotFound();

        return Ok(supplier);
    }

    // POST: api/Suppliers
    [HttpPost]
    public IActionResult Post(Supplier supplier)
    {
        _context.Suppliers.Add(supplier);
        _context.SaveChanges();
        return CreatedAtAction(nameof(Get), new { id = supplier.Id }, supplier);
    }

    // PUT: api/Suppliers/{id}
    [HttpPut("{id}")]
    public IActionResult Put(int id, Supplier updatedSupplier)
    {
        if (id != updatedSupplier.Id)
            return BadRequest();

        var supplier = _context.Suppliers.FirstOrDefault(s => s.Id == id);

        if (supplier == null)
            return NotFound();

        supplier.Name = updatedSupplier.Name;

        _context.SaveChanges();

        return NoContent();
    }

    // DELETE: api/Suppliers/{id}
    [HttpDelete("{id}")]
    public IActionResult Delete(int id)
    {
        var supplier = _context.Suppliers.FirstOrDefault(s => s.Id == id);

        if (supplier == null)
            return NotFound();

        _context.Suppliers.Remove(supplier);
        _context.SaveChanges();

        return NoContent();
    }
}