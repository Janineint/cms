namespace cms.Models
{
    public class Order
    {
        public int Id { get; set; }
        public DateTime OrderDate { get; set; }
        public List<ProductOrder> ProductOrders { get; set; }
    }
}