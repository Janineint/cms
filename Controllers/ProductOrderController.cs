using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using cms.Data;
using cms.Models;

[ApiController]
[Route("api/[controller]")]
public class ProductOrderController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public ProductOrderController(ApplicationDbContext context)
    {
        _context = context;
    }

    // GET: api/ProductOrder
    [HttpGet]
    public IActionResult Get()
    {
        var productOrders = (from po in _context.ProductOrders
                             join p in _context.Products on po.ProductId equals p.Id
                             join o in _context.Orders on po.OrderId equals o.Id
                             select new
                             {
                                 po.ProductId,
                                 ProductName = p.Name,
                                 po.OrderId,
                                 OrderDate = o.OrderDate
                             }).ToList();
        return Ok(productOrders);
    }

    // GET: api/ProductOrder/{productId}/{orderId}
    [HttpGet("{productId}/{orderId}")]
    public IActionResult Get(int productId, int orderId)
    {
        var productOrder = (from po in _context.ProductOrders
                            where po.ProductId == productId && po.OrderId == orderId
                            join p in _context.Products on po.ProductId equals p.Id
                            join o in _context.Orders on po.OrderId equals o.Id
                            select new
                            {
                                po.ProductId,
                                ProductName = p.Name,
                                po.OrderId,
                                OrderDate = o.OrderDate
                            }).FirstOrDefault();

        if (productOrder == null)
            return NotFound();

        return Ok(productOrder);
    }

    // POST: api/ProductOrder
    [HttpPost]
    public IActionResult Post(ProductOrder productOrder)
    {
        _context.ProductOrders.Add(productOrder);
        _context.SaveChanges();
        return CreatedAtAction(nameof(Get), new { productId = productOrder.ProductId, orderId = productOrder.OrderId }, productOrder);
    }

    // PUT: api/ProductOrder/{productId}/{orderId}
    [HttpPut("{productId}/{orderId}")]
    public IActionResult Put(int productId, int orderId, ProductOrder updatedProductOrder)
    {
        if (productId != updatedProductOrder.ProductId || orderId != updatedProductOrder.OrderId)
            return BadRequest();

        var productOrder = _context.ProductOrders.FirstOrDefault(po => po.ProductId == productId && po.OrderId == orderId);

        if (productOrder == null)
            return NotFound();

        productOrder.ProductId = updatedProductOrder.ProductId;
        productOrder.OrderId = updatedProductOrder.OrderId;

        _context.SaveChanges();

        return NoContent();
    }

    // DELETE: api/ProductOrder/{productId}/{orderId}
    [HttpDelete("{productId}/{orderId}")]
    public IActionResult Delete(int productId, int orderId)
    {
        var productOrder = _context.ProductOrders
            .FirstOrDefault(po => po.ProductId == productId && po.OrderId == orderId);

        if (productOrder == null)
            return NotFound();

        _context.ProductOrders.Remove(productOrder);
        _context.SaveChanges();

        return NoContent();
    }
}