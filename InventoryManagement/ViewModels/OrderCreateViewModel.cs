using System.ComponentModel.DataAnnotations;

namespace InventoryManagement.ViewModels
{
    public class OrderCreateViewModel
    {
        public int? StoreID { get; set; }

        [Required]
        public DateTime OrderDate { get; set; } = DateTime.Now;

        public List<OrderItemViewModel> Items { get; set; } = new List<OrderItemViewModel>();
    }
}
