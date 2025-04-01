using System.ComponentModel.DataAnnotations;

namespace InventoryManagement.Models
{
    public class Order
    {
        [Key]
        public int TransactionId { get; set; }

        [Required]
        public DateTime OrderDate { get; set; }

        public string? UserId { get; set; }
        public int? StoreID { get; set; }

        public decimal TotalCost { get; set; }

        public ApplicationUser User { get; set; }
        public Store Store { get; set; }

        public ICollection<OrderDetail> OrderDetails { get; set; } = new List<OrderDetail>();
    }
}
