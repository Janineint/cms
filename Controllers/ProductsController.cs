using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using cms.Data;
using cms.Models;

[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public ProductsController(ApplicationDbContext context)
    {
        _context = context;
    }

    // GET: api/Products
    [HttpGet]
    public IActionResult Get()
    {
        var products = (from p in _context.Products
                        select new
                        {
                            p.Id,
                            p.Name,
                            SupplierName = p.Supplier.Name
                        }).ToList();
        return Ok(products);
    }

    // GET: api/Products/{id}
    [HttpGet("{id}")]
    public IActionResult Get(int id)
    {
        var product = (from p in _context.Products
                       where p.Id == id
                       select new
                       {
                           p.Id,
                           p.Name,
                           SupplierName = p.Supplier.Name
                       }).FirstOrDefault();

        if (product == null)
            return NotFound();

        return Ok(product);
    }

    // POST: api/Products
    [HttpPost]
    public IActionResult Post(Product product)
    {
        _context.Products.Add(product);
        _context.SaveChanges();
        return CreatedAtAction(nameof(Get), new { id = product.Id }, product);
    }

    // PUT: api/Products/{id}
    [HttpPut("{id}")]
    public IActionResult Put(int id, Product updatedProduct)
    {
        if (id != updatedProduct.Id)
            return BadRequest();

        var product = _context.Products.FirstOrDefault(p => p.Id == id);

        if (product == null)
            return NotFound();

        product.Name = updatedProduct.Name;
        product.SupplierId = updatedProduct.SupplierId;

        _context.SaveChanges();

        return NoContent();
    }

    // DELETE: api/Products/{id}
    [HttpDelete("{id}")]
    public IActionResult Delete(int id)
    {
        var product = _context.Products.FirstOrDefault(p => p.Id == id);

        if (product == null)
            return NotFound();

        _context.Products.Remove(product);
        _context.SaveChanges();

        return NoContent();
    }
}