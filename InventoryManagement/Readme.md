# CMS (Inventory Management System)

This project is a basic Inventory Management System built primarily with **C#**, **ASP.NET Core MVC**, and **Entity Framework Core**, along with **HTML**, **CSS**, and **JavaScript**.  
It provides functionality to manage **Products**, **Suppliers**, **Stores**, **Customers**, and **Orders**.

---

## Features

- Manage inventory products
- Manage supplier information
- Manage store branches
- Manage customer records
- Create and view orders
- SQL scripts included to create database tables
- Secure user authentication and authorization (Identity Framework)

---

## Setup Instructions

1. **Clone this repository:**
   ```bash
   git clone https://github.com/Janineint/cms.git

2. **Open the project file in Visual Studio:**
InventoryManagement.sln

3. **Open a terminal (inside the project directory) and run the following commands:**
- Create a new initial migration
    ```bash
    dotnet ef migrations add InitialCreate

- Update the database with the latest schema
    ```bash
    dotnet ef database update

4. **Run the provided SQL scripts inside SQL Server Management Studio (SSMS) or your preferred SQL client:**
- SQLQuery-Product.sql

- SQLQuery-Suppliers.sql

- SQLQuery-Orders.sql

5. **Build and run the project**

## APIs

# Home API
- GET /Home/Index — Show homepage

- GET /Home/Privacy — Show privacy policy

- GET /Home/Error — Show error page

# Stores API
- GET /Store/Index — Get all stores

- GET /Store/Details/{id} — Get a store by ID

- POST /Store/Create — Create a new store

- PUT /Store/Edit/{id} — Update an existing store

- DELETE /Store/Delete/{id} — Delete a store

# Products API
- GET /Products/Index — Get all products

- GET /Products/Details/{id} — Get a product by ID

- POST /Products/Create — Add a new product

- PUT /Products/Edit/{id} — Update an existing product

- DELETE /Products/Delete/{id} — Delete a product

# Suppliers API
- GET /Suppliers/Index — Get all suppliers

- GET /Suppliers/Details/{id} — Get a supplier by ID

- POST /Suppliers/Create — Add a new supplier

- PUT /Suppliers/Edit/{id} — Update an existing supplier

- DELETE /Suppliers/Delete/{id} — Delete a supplier

# Orders API
- GET /Orders/Index — Get all orders

- GET /Orders/Details/{id} — Get an order by ID

- POST /Orders/Create — Create a new order

- PUT /Orders/Edit/{id} — Update an existing order

- DELETE /Orders/Delete/{id} — Delete an order