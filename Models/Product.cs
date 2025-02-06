namespace cms.Models
{
    public class Product
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int SupplierId { get; set; }
        public Supplier Supplier { get; set; }
        public List<ProductOrder> ProductOrders { get; set; }
    }
}