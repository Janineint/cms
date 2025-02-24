namespace cms.Models
{
    public class Order
    {
        public int Id { get; set; }
        public DateTime OrderDate { get; set; }
        public int Quantity { get; set; }
        public float TotalCost { get; set; } 
        public int ProductId { get; set; } 
        public Product Product { get; set; }
        public List<ProductOrder> ProductOrders { get; set; }
    }
}