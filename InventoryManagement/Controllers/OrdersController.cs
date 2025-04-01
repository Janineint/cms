using InventoryManagement.Models;
using InventoryManagement.ViewModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;

namespace InventoryManagement.Controllers
{
    [Authorize]
    public class OrdersController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly UserManager<ApplicationUser> _userManager;

        public OrdersController(ApplicationDbContext context, UserManager<ApplicationUser> userManager)
        {
            _context = context;
            _userManager = userManager;
        }

        public async Task<IActionResult> Index()
        {
            var orders = await _context.Orders
                .Include(o => o.Store)
                .Include(o => o.OrderDetails)
                    .ThenInclude(od => od.Product)
                .ToListAsync();

            return View(orders);
        }

        public IActionResult Create()
        {
            ViewData["StoreID"] = new SelectList(_context.Stores, "StoreID", "StoreName");
            ViewData["Products"] = _context.Products.Select(p => new
            {
                p.ProductId,
                Display = $"{p.ProductName} - ${p.UnitPrice}"
            }).ToList();

            return View(new OrderCreateViewModel
            {
                Items = new List<OrderItemViewModel> { new OrderItemViewModel() }
            });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(OrderCreateViewModel vm)
        {
            if (!ModelState.IsValid)
            {
                ViewData["StoreID"] = new SelectList(_context.Stores, "StoreID", "StoreName", vm.StoreID);
                ViewData["Products"] = _context.Products.Select(p => new
                {
                    p.ProductId,
                    Display = $"{p.ProductName} - ${p.UnitPrice}"
                }).ToList();
                return View(vm);
            }

            var userId = _userManager.GetUserId(User);

            var order = new Order
            {
                StoreID = vm.StoreID,
                OrderDate = vm.OrderDate,
                UserId = userId,
                OrderDetails = new List<OrderDetail>()
            };

            decimal total = 0;

            foreach (var item in vm.Items)
            {
                var product = await _context.Products.FindAsync(item.ProductId);
                if (product == null) continue;

                order.OrderDetails.Add(new OrderDetail
                {
                    ProductId = item.ProductId,
                    Quantity = item.Quantity,
                    UnitPrice = product.UnitPrice
                });

                total += product.UnitPrice * item.Quantity;
            }

            order.TotalCost = total;

            _context.Orders.Add(order);
            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Index));
        }

        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null) return NotFound();

            var order = await _context.Orders
                .Include(o => o.OrderDetails)
                .FirstOrDefaultAsync(o => o.TransactionId == id);

            if (order == null) return NotFound();

            ViewData["StoreID"] = new SelectList(_context.Stores, "StoreID", "StoreName", order.StoreID);
            ViewData["Products"] = _context.Products.Select(p => new
            {
                p.ProductId,
                Display = $"{p.ProductName} - ${p.UnitPrice}"
            }).ToList();

            var vm = new OrderCreateViewModel
            {
                StoreID = order.StoreID,
                OrderDate = order.OrderDate,
                Items = order.OrderDetails.Select(d => new OrderItemViewModel
                {
                    ProductId = d.ProductId,
                    Quantity = d.Quantity
                }).ToList()
            };

            ViewData["OrderId"] = order.TransactionId;

            return View(vm);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, OrderCreateViewModel vm)
        {
            var order = await _context.Orders.Include(o => o.OrderDetails)
                .FirstOrDefaultAsync(o => o.TransactionId == id);

            if (order == null) return NotFound();

            if (!ModelState.IsValid)
            {
                ViewData["StoreID"] = new SelectList(_context.Stores, "StoreID", "StoreName", vm.StoreID);
                ViewData["Products"] = _context.Products.Select(p => new
                {
                    p.ProductId,
                    Display = $"{p.ProductName} - ${p.UnitPrice}"
                }).ToList();
                ViewData["OrderId"] = id;
                return View(vm);
            }

            order.OrderDate = vm.OrderDate;
            order.StoreID = vm.StoreID;
            order.TotalCost = 0;

            _context.OrderDetails.RemoveRange(order.OrderDetails);

            foreach (var item in vm.Items)
            {
                var product = await _context.Products.FindAsync(item.ProductId);
                if (product == null) continue;

                order.OrderDetails.Add(new OrderDetail
                {
                    OrderId = order.TransactionId,
                    ProductId = item.ProductId,
                    Quantity = item.Quantity,
                    UnitPrice = product.UnitPrice
                });

                order.TotalCost += product.UnitPrice * item.Quantity;
            }

            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Index));
        }


        public async Task<IActionResult> Details(int? id)
        {
            if (id == null) return NotFound();

            var order = await _context.Orders
                .Include(o => o.Store)
                .Include(o => o.OrderDetails)
                    .ThenInclude(od => od.Product)
                .FirstOrDefaultAsync(o => o.TransactionId == id);

            return order == null ? NotFound() : View(order);
        }


        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null) return NotFound();

            var order = await _context.Orders
                .Include(o => o.Store)
                .FirstOrDefaultAsync(o => o.TransactionId == id);

            return order == null ? NotFound() : View(order);
        }


        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var order = await _context.Orders
                .Include(o => o.OrderDetails)
                .FirstOrDefaultAsync(o => o.TransactionId == id);

            _context.OrderDetails.RemoveRange(order.OrderDetails);
            _context.Orders.Remove(order);
            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Index));
        }

    }
}
