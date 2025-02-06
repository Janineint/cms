-- Create Database
CREATE DATABASE IF NOT EXISTS restaurant_management_system;
USE restaurant_management_system;

-- supplier table
CREATE TABLE supplier (
    supplier_id INT(11) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact VARCHAR(100) NOT NULL,
    phone CHAR(10) NOT NULL,
    email VARCHAR(30),
    address VARCHAR(200) NOT NULL,
    city VARCHAR(30) NOT NULL,
    province VARCHAR(3) NOT NULL,
    postal VARCHAR(6)
);

-- product table
CREATE TABLE product (
    product_id INT(11) PRIMARY KEY,
    supplier_id INT(11) NOT NULL,
    product VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    unit_size VARCHAR(50) NOT NULL,
    category VARCHAR(50) NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
);

-- order table
CREATE TABLE orders (
    transaction_id INT(11) PRIMARY KEY,
    supplier_id INT(11) NOT NULL,
    order_date DATE NOT NULL,
    product_id INT(11) NOT NULL,
    quantity INT(11) NOT NULL,
    total_cost DECIMAL(10, 2) NOT NULL,
    delivery_date DATE,
    FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);


-- Updated product_orders table with product_quantity field
CREATE TABLE product_orders (
    product_id INT(11),
    supplier_id INT(11),
    product_quantity INT(11), -- Added product_quantity field
    PRIMARY KEY (product_id, supplier_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
);


CREATE VIEW inventory_supplier_view AS
SELECT 
    p.product_id,
    p.product AS product_name,
    p.unit_price,
    p.unit_size,
    p.category,
    s.supplier_id,
    s.name AS supplier_name,
    s.contact AS supplier_contact,
    s.phone AS supplier_phone,
    po.product_quantity
FROM 
    product p
INNER JOIN 
    supplier s ON p.supplier_id = s.supplier_id
INNER JOIN 
    product_orders po ON p.product_id = po.product_id;



DELIMITER $$
CREATE TRIGGER calculate_total_cost_trigger
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE unit_price DECIMAL(10, 2);
    
    -- Fetch the unit price from the product table
    SELECT p.unit_price INTO unit_price
    FROM product p
    WHERE p.product_id = NEW.product_id;

    -- Calculate the total cost
    SET NEW.total_cost = NEW.quantity * unit_price;
END$$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE update_delivery_date_procedure (
    IN order_id INT,
    IN new_delivery_date DATE
)
BEGIN
    -- Update the delivery date for the given order
    UPDATE orders
    SET delivery_date = new_delivery_date
    WHERE transaction_id = order_id;
END$$
DELIMITER ;



-- Insert Data into `supplier` Table
INSERT INTO supplier (supplier_id, name, contact, phone, email, address, city, province, postal) VALUES
(1, 'Fresh Farms Produce', 'Alice Johnson', '4165551234', 'alice.j@freshfarms.com', '123 Green Street', 'Toronto', 'ON', 'M5H1J9'),
(2, 'Ocean Catch Fish Market', 'Bob Smith', '4165555678', 'bob.s@oceancatch.com', '456 Fisher Avenue', 'Mississauga', 'ON', 'L5B1G5'),
(3, 'Bakery Supplies Co.', 'Carol Williams', '6475551234', 'carol.w@bakerysupplies.com', '789 Baker Blvd', 'Ottawa', 'ON', 'K1A0B1'),
(4, 'Meat Masters', 'David Brown', '9055559876', 'david.b@meatmasters.com', '321 Carnivore Road', 'Pickering', 'ON', 'L1V2V4'),
(5, 'Dairy Delight', 'Eve Davis', '6135556543', 'eve.d@dairydelight.com', '654 Dairy Lane', 'Hamilton', 'ON', 'L8P3J6'),
(6, 'Spice World', 'Frank Thomas', '9055558765', 'frank.t@spiceworld.com', '987 Spice Drive', 'Brampton', 'ON', 'L6Y5H5'),
(7, 'Gourmet Goods', 'Grace Wilson', '4165553456', 'grace.w@gourmetgoods.com', '567 Gourmet Avenue', 'London', 'ON', 'N6A1A6'),
(8, 'Vegetable Valley', 'Henry White', '6475558765', 'henry.w@vegetablevalley.com', '234 Veggie Road', 'Kingston', 'ON', 'K7K1M1'),
(9, 'Coffee and Tea Suppliers', 'Ivy Green', '9055551234', 'ivy.g@coffeeandtea.com', '876 Beverage Park', 'Kitchener', 'ON', 'N2H2N2'),
(10, 'Pasta Central', 'Jack Black', '6135559876', 'jack.b@pastacentral.com', '543 Noodle Way', 'Markham', 'ON', 'L3R1G1'),
(11, 'Fruit Fiesta', 'Karen Lee', '9055555678', 'karen.l@fruitfiesta.com', '210 Fruit Street', 'Richmond Hill', 'ON', 'L4B4V3'),
(12, 'Bakery Best', 'Liam Adams', '6475558765', 'liam.a@bakerybest.com', '678 Bread Plaza', 'Burlington', 'ON', 'L7R3V5'),
(13, 'Condiment Corner', 'Mia Moore', '4165552345', 'mia.m@condimentcorner.com', '345 Flavor Blvd', 'Vaughan', 'ON', 'L4K2W8'),
(14, 'Seafood Sensations', 'Nina Clark', '9055553456', 'nina.c@seafoodsensations.com', '789 Ocean Avenue', 'St. Catharines', 'ON', 'L2R6P9'),
(15, 'Poultry Plus', 'Oscar Harris', '6135556543', 'oscar.h@poultryplus.com', '432 Chicken Lane', 'Waterloo', 'ON', 'N2L3G1'),
(16, 'Seasonal Suppliers', 'Pam King', '9055558765', 'pam.k@seasonalsuppliers.com', '210 Seasonal Blvd', 'Whitby', 'ON', 'L1N8Y9'),
(17, 'Beverage Brothers', 'Quincy Martin', '6475552345', 'quincy.m@beveragebrothers.com', '654 Drink Street', 'Oshawa', 'ON', 'L1G5Y7'),
(18, 'Gourmet Greens', 'Rachel Perez', '9055559876', 'rachel.p@gourmetgreens.com', '987 Gourmet Drive', 'Aurora', 'ON', 'L4G6V7'),
(19, 'Sweet Treats Supply', 'Sam Roberts', '4165553456', 'sam.r@sweettreats.com', '543 Candy Parkway', 'Barrie', 'ON', 'L4N9Y8'),
(20, 'Frozen Foods Inc.', 'Tina Brown', '6135558765', 'tina.b@frozenfoods.com', '210 Ice Park', 'Newmarket', 'ON', 'L3Y4V9'),
(21, 'Organic Oasis', 'Uma Smith', '9055552345', 'uma.s@organicoasis.com', '432 Organic Avenue', 'Milton', 'ON', 'L9T2N3'),
(22, 'Gourmet Grocers', 'Victor White', '6475559876', 'victor.w@gourmetgrocers.com', '678 Grocery Street', 'Guelph', 'ON', 'N1G5E3'),
(23, 'Fine Food Suppliers', 'Wendy Young', '9055556543', 'wendy.y@finefoods.com', '345 Fine Lane', 'Oakville', 'ON', 'L6H5Y7');



-- Insert Data into `product` Table
INSERT INTO product (product_id, supplier_id, product, unit_price, unit_size, category) VALUES
(1, 1, 'Apples', 3.50, 'kg', 'Fruits'),
(2, 1, 'Bananas', 1.20, 'kg', 'Fruits'),
(3, 2, 'Salmon Fillet', 12.00, 'kg', 'Seafood'),
(4, 2, 'Cod Fillet', 10.00, 'kg', 'Seafood'),
(5, 3, 'Wheat Flour', 2.80, 'kg', 'Bakery'),
(6, 3, 'Sugar', 1.00, 'kg', 'Bakery'),
(7, 4, 'Chicken Breast', 8.00, 'kg', 'Meat'),
(8, 4, 'Beef Steak', 15.00, 'kg', 'Meat'),
(9, 5, 'Cheddar Cheese', 5.00, 'kg', 'Dairy'),
(10, 5, 'Butter', 4.00, 'kg', 'Dairy'),
(11, 6, 'Black Pepper', 10.00, 'kg', 'Spices'),
(12, 6, 'Turmeric', 8.00, 'kg', 'Spices'),
(13, 7, 'Olive Oil', 7.00, 'litre', 'Oil'),
(14, 7, 'Vinegar', 4.00, 'litre', 'Condiments'),
(15, 8, 'Lettuce', 1.50, 'kg', 'Vegetables'),
(16, 8, 'Tomatoes', 2.20, 'kg', 'Vegetables'),
(17, 9, 'Coffee Beans', 15.00, 'kg', 'Beverages'),
(18, 9, 'Tea Bags', 12.00, 'box', 'Beverages'),
(19, 10, 'Spaghetti', 2.50, 'kg', 'Pasta'),
(20, 10, 'Penne', 3.00, 'kg', 'Pasta'),
(21, 11, 'Oranges', 3.00, 'kg', 'Fruits'),
(22, 11, 'Grapes', 4.50, 'kg', 'Fruits'),
(23, 12, 'Croissants', 1.50, 'each', 'Bakery'),
(24, 12, 'Bagels', 1.00, 'each', 'Bakery'),
(25, 13, 'Ketchup', 3.00, 'bottle', 'Condiments'),
(26, 13, 'Mayonnaise', 3.50, 'bottle', 'Condiments'),
(27, 14, 'Shrimps', 15.00, 'kg', 'Seafood'),
(28, 14, 'Scallops', 20.00, 'kg', 'Seafood'),
(29, 15, 'Turkey', 10.00, 'kg', 'Meat'),
(30, 15, 'Pork Chop', 9.00, 'kg', 'Meat'),
(31, 16, 'Seasonal Vegetables', 5.00, 'kg', 'Vegetables'),
(32, 16, 'Mixed Herbs', 6.00, 'kg', 'Spices'),
(33, 17, 'Orange Juice', 4.00, 'litre', 'Beverages'),
(34, 17, 'Apple Juice', 3.50, 'litre', 'Beverages'),
(35, 18, 'Spinach', 2.50, 'kg', 'Vegetables'),
(36, 18, 'Kale', 3.00, 'kg', 'Vegetables'),
(37, 19, 'Chocolate Chips', 8.00, 'kg', 'Bakery'),
(38, 19, 'Cake Mix', 5.00, 'box', 'Bakery'),
(39, 20, 'Frozen Peas', 3.00, 'kg', 'Frozen Food'),
(40, 20, 'Frozen Corn', 2.50, 'kg', 'Frozen Food'),
(41, 21, 'Organic Carrots', 2.80, 'kg', 'Vegetables'),
(42, 21, 'Organic Potatoes', 1.80, 'kg', 'Vegetables'),
(43, 22, 'Gourmet Crackers', 4.50, 'box', 'Snacks'),
(44, 22, 'Gourmet Popcorn', 5.00, 'bag', 'Snacks'),
(45, 23, 'Pastry Flour', 3.20, 'kg', 'Bakery'),
(46, 23, 'Baking Soda', 1.50, 'kg', 'Bakery'),
(47, 1, 'Blueberries', 5.00, 'kg', 'Fruits'),
(48, 1, 'Strawberries', 6.00, 'kg', 'Fruits'),
(49, 2, 'Mackerel', 9.00, 'kg', 'Seafood'),
(50, 2, 'Tuna', 11.00, 'kg', 'Seafood'),
(51, 3, 'Rye Flour', 3.50, 'kg', 'Bakery'),
(52, 3, 'Cornmeal', 2.00, 'kg', 'Bakery'),
(53, 4, 'Ground Beef', 7.00, 'kg', 'Meat'),
(54, 4, 'Pork Belly', 10.00, 'kg', 'Meat'),
(55, 5, 'Mozzarella Cheese', 5.50, 'kg', 'Dairy'),
(56, 5, 'Greek Yogurt', 6.00, 'kg', 'Dairy'),
(57, 6, 'Cinnamon', 12.00, 'kg', 'Spices'),
(58, 6, 'Nutmeg', 11.00, 'kg', 'Spices'),
(59, 7, 'Sesame Oil', 8.00, 'litre', 'Oil'),
(60, 7, 'Soy Sauce', 6.00, 'litre', 'Condiments'),
(61, 8, 'Broccoli', 3.20, 'kg', 'Vegetables'),
(62, 8, 'Cauliflower', 2.80, 'kg', 'Vegetables'),
(63, 9, 'Hot Chocolate Mix', 10.00, 'kg', 'Beverages'),
(64, 9, 'Herbal Tea', 8.00, 'box', 'Beverages'),
(65, 10, 'Lasagna Sheets', 4.00, 'kg', 'Pasta'),
(66, 10, 'Ravioli', 5.00, 'kg', 'Pasta'),
(67, 11, 'Pineapple', 3.80, 'kg', 'Fruits'),
(68, 11, 'Mango', 4.00, 'kg', 'Fruits'),
(69, 12, 'Muffins', 2.00, 'each', 'Bakery'),
(70, 12, 'Cookies', 1.50, 'each', 'Bakery'),
(71, 13, 'Mustard', 3.20, 'bottle', 'Condiments'),
(72, 13, 'Barbecue Sauce', 4.00, 'bottle', 'Condiments'),
(73, 14, 'Lobster', 25.00, 'kg', 'Seafood'),
(74, 14, 'Crab', 22.00, 'kg', 'Seafood'),
(75, 15, 'Lamb Chops', 18.00, 'kg', 'Meat'),
(76, 15, 'Duck Breast', 20.00, 'kg', 'Meat'),
(77, 16, 'Chives', 6.00, 'kg', 'Spices'),
(78, 16, 'Rosemary', 5.00, 'kg', 'Spices'),
(79, 17, 'Cranberry Juice', 4.50, 'litre', 'Beverages'),
(80, 17, 'Pineapple Juice', 4.00, 'litre', 'Beverages'),
(81, 18, 'Zucchini', 3.00, 'kg', 'Vegetables'),
(82, 18, 'Eggplant', 2.80, 'kg', 'Vegetables'),
(83, 19, 'Brownie Mix', 6.00, 'box', 'Bakery'),
(84, 19, 'Pancake Mix', 4.50, 'box', 'Bakery'),
(85, 20, 'Frozen Broccoli', 3.50, 'kg', 'Frozen Food'),
(86, 20, 'Frozen Spinach', 3.00, 'kg', 'Frozen Food'),
(87, 21, 'Organic Spinach', 3.20, 'kg', 'Vegetables'),
(88, 21, 'Organic Lettuce', 2.10, 'kg', 'Vegetables'),
(89, 22, 'Gourmet Granola', 5.50, 'box', 'Snacks'),
(90, 22, 'Organic Almonds', 7.00, 'kg', 'Snacks'),
(91, 23, 'Baking Powder', 2.20, 'kg', 'Bakery'),
(92, 23, 'Yeast', 1.80, 'kg', 'Bakery'),
(93, 1, 'Raspberries', 6.00, 'kg', 'Fruits'),
(94, 1, 'Blackberries', 6.50, 'kg', 'Fruits'),
(95, 2, 'Haddock Fillet', 12.50, 'kg', 'Seafood'),
(96, 2, 'Tilapia Fillet', 9.50, 'kg', 'Seafood'),
(97, 3, 'Sourdough Flour', 3.00, 'kg', 'Bakery'),
(98, 3, 'Semolina', 2.50, 'kg', 'Bakery'),
(99, 4, 'Lamb Shank', 17.00, 'kg', 'Meat'),
(100, 4, 'Veal Cutlets', 16.00, 'kg', 'Meat'),
(101, 5, 'Parmesan Cheese', 7.00, 'kg', 'Dairy'),
(102, 5, 'Cream Cheese', 4.50, 'kg', 'Dairy'),
(103, 6, 'Paprika', 9.00, 'kg', 'Spices'),
(104, 6, 'Ginger', 7.50, 'kg', 'Spices'),
(105, 7, 'Coconut Oil', 7.00, 'litre', 'Oil'),
(106, 7, 'Chili Sauce', 5.00, 'litre', 'Condiments'),
(107, 8, 'Green Beans', 3.00, 'kg', 'Vegetables'),
(108, 8, 'Asparagus', 4.00, 'kg', 'Vegetables'),
(109, 9, 'Espresso Beans', 16.00, 'kg', 'Beverages'),
(110, 9, 'Matcha Powder', 18.00, 'kg', 'Beverages'),
(111, 10, 'Fusilli', 3.00, 'kg', 'Pasta'),
(112, 10, 'Linguine', 3.50, 'kg', 'Pasta'),
(113, 11, 'Peaches', 3.50, 'kg', 'Fruits'),
(114, 11, 'Plums', 4.00, 'kg', 'Fruits'),
(115, 12, 'Danish Pastries', 2.50, 'each', 'Bakery'),
(116, 12, 'Scones', 2.00, 'each', 'Bakery'),
(117, 13, 'Relish', 2.80, 'bottle', 'Condiments'),
(118, 13, 'Hot Sauce', 3.50, 'bottle', 'Condiments'),
(119, 14, 'Calamari', 13.00, 'kg', 'Seafood'),
(120, 14, 'Mussels', 10.50, 'kg', 'Seafood'),
(121, 15, 'Goat Meat', 14.00, 'kg', 'Meat'),
(122, 15, 'Pork Ribs', 11.00, 'kg', 'Meat'),
(123, 16, 'Dill', 5.00, 'kg', 'Spices'),
(124, 16, 'Oregano', 4.50, 'kg', 'Spices'),
(125, 17, 'Grapefruit Juice', 4.00, 'litre', 'Beverages'),
(126, 17, 'Lemonade', 3.80, 'litre', 'Beverages'),
(127, 18, 'Beetroot', 2.50, 'kg', 'Vegetables'),
(128, 18, 'Radishes', 2.00, 'kg', 'Vegetables'),
(129, 19, 'Doughnut Mix', 5.00, 'box', 'Bakery'),
(130, 19, 'Waffle Mix', 6.00, 'box', 'Bakery'),
(131, 20, 'Frozen Carrots', 2.80, 'kg', 'Frozen Food'),
(132, 20, 'Frozen Mixed Vegetables', 3.20, 'kg', 'Frozen Food'),
(133, 21, 'Organic Beets', 3.00, 'kg', 'Vegetables'),
(134, 21, 'Organic Kale', 3.50, 'kg', 'Vegetables'),
(135, 22, 'Protein Bars', 6.00, 'box', 'Snacks'),
(136, 22, 'Trail Mix', 5.50, 'kg', 'Snacks'),
(137, 23, 'Brown Sugar', 2.00, 'kg', 'Bakery'),
(138, 23, 'Molasses', 3.00, 'kg', 'Bakery'),
(139, 1, 'Pears', 2.80, 'kg', 'Fruits'),
(140, 1, 'Kiwi', 4.00, 'kg', 'Fruits'),
(141, 2, 'Clams', 8.50, 'kg', 'Seafood'),
(142, 2, 'Oysters', 15.00, 'kg', 'Seafood'),
(143, 3, 'Brioche Flour', 3.50, 'kg', 'Bakery'),
(144, 3, 'Bread Crumbs', 2.00, 'kg', 'Bakery'),
(145, 4, 'Duck Leg', 13.00, 'kg', 'Meat'),
(146, 4, 'Rabbit Meat', 18.00, 'kg', 'Meat'),
(147, 5, 'Swiss Cheese', 6.00, 'kg', 'Dairy'),
(148, 5, 'Cottage Cheese', 4.00, 'kg', 'Dairy'),
(149, 6, 'Bay Leaves', 12.00, 'kg', 'Spices'),
(150, 6, 'Cloves', 10.00, 'kg', 'Spices'),
(151, 7, 'Peanut Oil', 9.00, 'litre', 'Oil'),
(152, 7, 'Garlic Sauce', 4.50, 'litre', 'Condiments'),
(153, 8, 'Sweet Peppers', 3.50, 'kg', 'Vegetables'),
(154, 8, 'Cucumbers', 2.20, 'kg', 'Vegetables'),
(155, 9, 'Decaf Coffee', 14.00, 'kg', 'Beverages'),
(156, 9, 'Chai Tea', 10.00, 'box', 'Beverages'),
(157, 10, 'Gnocchi', 4.00, 'kg', 'Pasta'),
(158, 10, 'Cannelloni', 5.00, 'kg', 'Pasta'),
(159, 11, 'Cherries', 4.50, 'kg', 'Fruits'),
(160, 11, 'Figs', 5.00, 'kg', 'Fruits'),
(161, 12, 'Pies', 3.00, 'each', 'Bakery'),
(162, 12, 'Tarts', 2.50, 'each', 'Bakery'),
(163, 13, 'Soy Sauce', 3.00, 'bottle', 'Condiments'),
(164, 13, 'Fish Sauce', 4.00, 'bottle', 'Condiments'),
(165, 14, 'Crawfish', 12.00, 'kg', 'Seafood'),
(166, 14, 'King Crab', 28.00, 'kg', 'Seafood'),
(167, 15, 'Venison', 22.00, 'kg', 'Meat'),
(168, 15, 'Quail', 15.00, 'kg', 'Meat'),
(169, 16, 'Basil', 4.00, 'kg', 'Spices'),
(170, 16, 'Mint', 3.50, 'kg', 'Spices'),
(171, 17, 'Tomato Juice', 3.50, 'litre', 'Beverages'),
(172, 17, 'Iced Tea', 4.50, 'litre', 'Beverages'),
(173, 18, 'Leeks', 2.80, 'kg', 'Vegetables'),
(174, 18, 'Artichokes', 4.00, 'kg', 'Vegetables'),
(175, 19, 'Pudding Mix', 3.00, 'box', 'Bakery'),
(176, 19, 'Custard Mix', 4.00, 'box', 'Bakery');

-- Insert Data into `order` Table
-- Insert Data into `order` Table
INSERT INTO orders (transaction_id, supplier_id, order_date, product_id, quantity, total_cost, delivery_date) VALUES
(1, 1, '2024-03-27', 2, 58, 153.04, '2024-04-15'),
(2, 2, '2024-05-14', 3, 45, 540.00, '2024-06-01'),
(3, 3, '2024-07-22', 5, 30, 84.00, '2024-08-10'),
(4, 4, '2024-09-10', 7, 25, 200.00, '2024-09-25'),
(5, 11, '2024-09-05', 21, 39, 353.10, '2024-12-29'),
(6, 6, '2024-11-11', 11, 50, 500.00, '2024-11-25'),
(7, 7, '2024-12-01', 13, 60, 420.00, '2024-12-15'),
(8, 8, '2024-01-15', 15, 70, 105.00, '2024-01-30'),
(9, 9, '2024-02-20', 17, 80, 1200.00, '2024-03-05'),
(10, 10, '2024-03-25', 19, 90, 225.00, '2024-04-10'),
(11, 11, '2024-04-30', 21, 100, 300.00, '2024-05-15'),
(12, 7, '2024-11-25', 13, 72, 91.19, '2025-05-06'),
(13, 13, '2024-06-05', 25, 110, 330.00, '2024-06-20'),
(14, 14, '2024-07-10', 27, 120, 1800.00, '2024-07-25'),
(15, 10, '2024-01-14', 19, 68, 245.24, '2024-05-29'),
(16, 9, '2024-08-30', 17, 92, 368.94, '2024-10-06'),
(17, 17, '2024-09-15', 33, 130, 520.00, '2024-09-30'),
(18, 9, '2024-01-26', 18, 94, 530.18, '2024-08-30'),
(19, 19, '2024-10-20', 37, 140, 1120.00, '2024-11-04'),
(20, 5, '2024-07-09', 9, 58, 346.58, '2025-02-15'),
(21, 21, '2024-11-25', 41, 150, 420.00, '2024-12-10'),
(22, 22, '2024-12-30', 43, 160, 720.00, '2025-01-14'),
(23, 23, '2024-01-10', 45, 170, 544.00, '2024-01-25'),
(24, 12, '2024-10-06', 23, 24, 90.05, '2024-11-30'),
(25, 12, '2024-09-16', 24, 22, 330.34, '2025-02-12'),
(26, 2, '2024-02-05', 4, 180, 1800.00, '2024-02-20'),
(27, 3, '2024-03-12', 6, 190, 190.00, '2024-03-27'),
(28, 4, '2024-04-17', 8, 200, 3000.00, '2024-05-02'),
(29, 5, '2024-05-22', 10, 210, 840.00, '2024-06-06'),
(30, 6, '2024-06-27', 12, 220, 1760.00, '2024-07-12'),
(31, 7, '2024-08-02', 14, 230, 920.00, '2024-08-17'),
(32, 8, '2024-09-07', 16, 240, 528.00, '2024-09-22'),
(33, 9, '2024-10-12', 18, 250, 3000.00, '2024-10-27'),
(34, 10, '2024-11-17', 20, 260, 780.00, '2024-12-02'),
(35, 11, '2024-12-22', 22, 270, 1215.00, '2025-01-06'),
(36, 12, '2024-01-27', 24, 280, 280.00, '2024-02-11'),
(37, 13, '2024-03-03', 26, 290, 1015.00, '2024-03-18'),
(38, 14, '2024-04-08', 28, 300, 6000.00, '2024-04-23'),
(39, 15, '2024-05-13', 30, 310, 2790.00, '2024-05-28'),
(40, 16, '2024-06-18', 32, 320, 1920.00, '2024-07-03'),
(41, 17, '2024-07-23', 34, 330, 2310.00, '2024-08-07'),
(42, 18, '2024-08-28', 36, 340, 2380.00, '2024-09-12'),
(43, 19, '2024-10-03', 38, 350, 2800.00, '2024-10-18'),
(44, 20, '2024-11-08', 40, 360, 2880.00, '2024-11-23'),
(45, 21, '2024-12-13', 42, 370, 3700.00, '2024-12-28'),
(46, 22, '2024-01-18', 44, 380, 3800.00, '2024-02-02'),
(47, 23, '2024-02-22', 46, 390, 3900.00, '2024-03-08'),
(48, 1, '2024-03-28', 1, 400, 1400.00, '2024-04-12'),
(49, 2, '2024-05-03', 3, 410, 4920.00, '2024-05-18'),
(50, 3, '2024-06-07', 5, 420, 1176.00, '2024-06-22'),
(51, 4, '2024-07-12', 7, 430, 3440.00, '2024-07-27'),
(52, 5, '2024-08-16', 9, 440, 2200.00, '2024-08-31'),
(53, 6, '2024-09-20', 11, 450, 4500.00, '2024-10-05'),
(54, 7, '2024-10-25', 13, 460, 3220.00, '2024-11-09'),
(55, 8, '2024-11-29', 15, 470, 7050.00, '2024-12-14'),
(56, 9, '2024-01-03', 17, 480, 7200.00, '2024-01-18'),
(57, 10, '2024-02-07', 19, 490, 1225.00, '2024-02-22'),
(58, 11, '2024-03-13', 21, 500, 1500.00, '2024-03-28'),
(59, 12, '2024-08-30', 24, 27, 285.08, '2025-06-02'),
(60, 4, '2024-10-05', 7, 57, 340.18, '2024-12-02'),
(61, 6, '2024-02-23', 11, 52, 440.85, '2025-02-04'),
(62, 7, '2024-11-11', 13, 50, 500.00, '2024-11-25'),
(63, 8, '2024-12-01', 15, 60, 420.00, '2024-12-15'),
(64, 6, '2024-10-08', 12, 72, 649.09, '2025-01-20'),
(65, 9, '2024-02-20', 17, 80, 1200.00, '2024-03-05'),
(66, 4, '2024-03-13', 7, 53, 742.44, '2024-11-04'),
(67, 12, '2024-04-07', 24, 15, 276.24, '2024-11-12'),
(68, 9, '2024-01-26', 18, 94, 530.18, '2024-08-30'),
(69, 19, '2024-10-20', 37, 140, 1120.00, '2024-11-04'),
(70, 1, '2024-10-13', 2, 95, 216.69, '2025-01-10'),
(71, 21, '2024-11-25', 41, 150, 420.00, '2024-12-10'),
(72, 11, '2024-04-16', 21, 15, 191.32, '2025-01-27'),
(73, 2, '2024-10-28', 4, 81, 143.64, '2025-08-22'),
(74, 14, '2024-11-08', 28, 300, 6000.00, '2024-11-23'),
(75, 15, '2024-12-13', 30, 310, 2790.00, '2024-12-28'),
(76, 16, '2024-01-18', 32, 320, 1920.00, '2024-02-02'),
(77, 17, '2024-02-22', 34, 330, 2310.00, '2024-03-08'),
(78, 18, '2024-03-28', 36, 340, 2380.00, '2024-04-12'),
(79, 20, '2024-05-03', 40, 360, 2880.00, '2024-05-18'),
(80, 21, '2024-06-07', 42, 370, 3700.00, '2024-06-22'),
(81, 22, '2024-07-12', 44, 380, 3800.00, '2024-07-27'),
(82, 23, '2024-08-16', 46, 390, 3900.00, '2024-08-31'),
(83, 1, '2024-09-20', 1, 400, 1400.00, '2024-10-05'),
(84, 2, '2024-10-25', 3, 410, 4920.00, '2024-11-09'),
(85, 3, '2024-11-29', 5, 420, 1176.00, '2024-12-14'),
(86, 4, '2024-01-03', 7, 430, 3440.00, '2024-01-18'),
(87, 5, '2024-02-07', 9, 440, 2200.00, '2024-02-22'),
(88, 6, '2024-03-13', 11, 450, 4500.00, '2024-03-28'),
(89, 7, '2024-04-17', 13, 460, 3220.00, '2024-05-02'),
(90, 8, '2024-05-22', 15, 470, 7050.00, '2024-06-06'),
(91, 9, '2024-06-27', 17, 480, 7200.00, '2024-07-12'),
(92, 10, '2024-08-02', 19, 490, 1225.00, '2024-08-17'),
(93, 11, '2024-09-07', 21, 500, 1500.00, '2024-09-22'),
(94, 12, '2024-10-12', 23, 510, 7650.00, '2024-10-27'),
(95, 13, '2024-11-17', 25, 520, 10400.00, '2024-12-02'),
(96, 14, '2024-12-22', 27, 530, 11130.00, '2025-01-06'),
(97, 15, '2024-01-27', 29, 540, 11880.00, '2024-02-11'),
(98, 16, '2024-03-03', 31, 550, 12650.00, '2024-03-18'),
(99, 17, '2024-04-08', 33, 560, 13440.00, '2024-04-23'),
(100, 18, '2024-05-13', 35, 570, 14250.00, '2024-05-28'),
(101, 19, '2024-06-18', 37, 580, 15080.00, '2024-07-03'),
(102, 20, '2024-07-23', 39, 590, 15930.00, '2024-08-07'),
(103, 21, '2024-08-28', 41, 600, 16800.00, '2024-09-12'),
(104, 22, '2024-10-03', 43, 610, 17690.00, '2024-10-18'),
(105, 23, '2024-11-08', 45, 620, 18600.00, '2024-11-23'),
(106, 1, '2024-12-13', 1, 630, 19530.00, '2024-12-28'),
(107, 2, '2024-01-18', 3, 640, 20480.00, '2024-02-02'),
(108, 3, '2024-02-22', 5, 650, 21450.00, '2024-03-08'),
(109, 4, '2024-03-28', 7, 660, 22440.00, '2024-04-12'),
(110, 5, '2024-05-03', 9, 670, 23450.00, '2024-05-18'),
(111, 6, '2024-06-07', 11, 680, 24480.00, '2024-06-22'),
(112, 7, '2024-07-12', 13, 690, 25530.00, '2024-07-27'),
(113, 8, '2024-08-16', 15, 700, 26600.00, '2024-08-31'),
(114, 9, '2024-09-20', 17, 710, 27690.00, '2024-10-05'),
(115, 10, '2024-10-25', 19, 720, 28800.00, '2024-11-09'),
(116, 11, '2024-11-29', 21, 730, 29930.00, '2024-12-14');


-- Insert Data into `product_orders` Table
INSERT INTO product_orders (product_id, supplier_id, product_quantity) VALUES
(1, 1, 20),  -- 20 Apples for order 1
(2, 1, 30),  -- 30 Bananas for order 1
(3, 2, 10),  -- 10 Salmon Fillets for order 2
(4, 3, 15),  -- 15 Shrimp for order 3
(5, 3, 5);   -- 5 Truffle Oil for order 3

-- NOTE: Ensure that procedures perform multi-step operations and simplify complex tasks.