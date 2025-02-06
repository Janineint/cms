using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using cms.Data;
using cms.Models;

[ApiController]
[Route("api/[controller]")]
public class OrdersController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public OrdersController(ApplicationDbContext context)
    {
        _context = context;
    }

    // GET: api/Orders
    [HttpGet]
    public IActionResult Get()
    {
        var orders = (from o in _context.Orders
                      select new
                      {
                          o.Id,
                          o.OrderDate,
                          Products = o.ProductOrders.Select(po => new
                          {
                              po.ProductId,
                              ProductName = po.Product.Name
                          }).ToList()
                      }).ToList();

        return Ok(orders);
    }

    // GET: api/Orders/{id}
    [HttpGet("{id}")]
    public IActionResult Get(int id)
    {
        var order = (from o in _context.Orders
                     where o.Id == id
                     select new
                     {
                         o.Id,
                         o.OrderDate,
                         Products = o.ProductOrders.Select(po => new
                         {
                             po.ProductId,
                             ProductName = po.Product.Name
                         }).ToList()
                     }).FirstOrDefault();

        if (order == null)
            return NotFound();

        return Ok(order);
    }

    // POST: api/Orders
    [HttpPost]
    public IActionResult Post(Order order)
    {
        _context.Orders.Add(order);
        _context.SaveChanges();
        return CreatedAtAction(nameof(Get), new { id = order.Id }, order);
    }

    // PUT: api/Orders/{id}
    [HttpPut("{id}")]
    public IActionResult Put(int id, Order updatedOrder)
    {
        if (id != updatedOrder.Id)
            return BadRequest();

        var order = _context.Orders.FirstOrDefault(o => o.Id == id);

        if (order == null)
            return NotFound();

        order.OrderDate = updatedOrder.OrderDate;

        _context.SaveChanges();

        return NoContent();
    }

    // DELETE: api/Orders/{id}
    [HttpDelete("{id}")]
    public IActionResult Delete(int id)
    {
        var order = _context.Orders.FirstOrDefault(o => o.Id == id);

        if (order == null)
            return NotFound();

        _context.Orders.Remove(order);
        _context.SaveChanges();

        return NoContent();
    }
}
