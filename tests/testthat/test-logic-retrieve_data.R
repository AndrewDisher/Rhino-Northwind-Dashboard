# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  testthat[...],
  dplyr[`%>%`]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic/retrieve_data
)

# -------------------------------------------------------------------------
# ---------------------------------- Tests --------------------------------
# -------------------------------------------------------------------------

# File path for database (only needed for tests since rhino::test_r changes directory)
DB_path <- "../../data/northwind.db"

# --------------------------------
# ----- fetch_revenue_data() -----
# --------------------------------
test_that("fetch_revenue_data() returns correct columns", {
  # Expected column names
  column_names <- c("OrderDate", "RequiredDate", "ShippedDate", "B4_Discount", 
                    "After_Discount", "Country", "Freight", "Year", "Month", 
                    "Month_Number", "New_Date")
  
  # Alphabetical ordering
  column_names <- column_names %>% 
    sort()
  
  # Expectation
  expect_identical(retrieve_data$fetch_revenue_data(file_path = DB_path) %>% 
                     colnames() %>% 
                     sort(), 
                   column_names)
})

# --------------------------------------------
# ----- fetch_revenue_data_by_category() -----
# --------------------------------------------
test_that("fetch_revenue_data_by_category() returns correct columns", {
  # Expected column names
  column_names <- c("OrderDate", "Category", "B4_Discount", "After_Discount", 
                    "Year", "Month", "Month_Number")
  
  # Alphabetical ordering
  column_names <- column_names %>% 
    sort()
  
  # Expectation
  expect_identical(retrieve_data$fetch_revenue_data_by_category(file_path = DB_path) %>% 
                     colnames() %>% 
                     sort(), 
                   column_names)
})

# -----------------------------
# ----- fetch_employees() -----
# -----------------------------
test_that("fetch_employees() returns correct list information", {
  # Expected column names
  column_names <- c("Photo", "FullName", "Notes", "HireDate", "Region", "Country",
                    "HomePhone", "City", "TitleOfCourtesy", "Title", "ReportsTo",
                    "EmployeeID")
  
  # Alphabetical ordering
  column_names <- column_names %>% 
    sort()
  
  # Expected employee names
  employee_names <- c("Nancy Davolio", "Andrew Fuller", "Janet Leverling", "Margaret Peacock",
                      "Steven Buchanan", "Michael Suyama", "Robert King", "Laura Callahan",
                      "Anne Dodsworth") %>% sort()
  
  # Expectation: data returns correct columns
  expect_identical(retrieve_data$fetch_employees(file_path = DB_path)$data %>% 
                     colnames() %>% 
                     sort(), 
                   column_names)
  
  # Expectation: names returns correct employees' names
  expect_identical(retrieve_data$fetch_employees(file_path = DB_path)$names %>%
                     sort(),
                   employee_names)
})

# -----------------------------------
# ----- fetch_employee_orders() -----
# -----------------------------------
test_that("fetch_employee_orders() returns correct columns", {
  # Expected column names
  column_names <- c("OrderID", "Customer", "FullName", "OrderDate", "RequiredDate",
                    "ShippedDate", "Revenue", "Freight", "ShipAddress", "ShipCity",      
                    "ShipPostalCode", "ShipCountry", "Year", "Month_Number", 
                    "New_Date")
  
  # Alphabetical ordering
  column_names <- column_names %>% 
    sort()
  
  # Expectation
  expect_identical(retrieve_data$fetch_employee_orders(file_path = DB_path) %>% 
                     colnames() %>% 
                     sort(), 
                   column_names)
})

# ----------------------------------
# ----- fetch_products_table() -----
# ----------------------------------
test_that("fetch_products_table() returns correct columns", {
  column_names <- c("ProductID", "ProductName", "QuantityPerUnit", "UnitPrice",
                    "UnitsInStock", "UnitsOnOrder", "ReorderLevel", "Discontinued",
                    "CategoryID", "Category")
  
  # Alphabetical ordering
  column_names <- column_names %>% 
    sort()
  
  # Expectation
  expect_identical(retrieve_data$fetch_products_table(file_path = DB_path) %>% 
                     colnames() %>% 
                     sort(), 
                   column_names)
})

# ----------------------------------
# ----- fetch_product_orders() -----
# ----------------------------------
test_that("fetch_product_orders() returns correct columns", {
  column_names <- c("ProductID", "OrderID", "CustomerID", "OrderDate", "ShippedDate",
                    "ShipCountry", "ProductName", "QuantityPerUnit", "UnitPrice",      
                    "UnitsInStock", "UnitsOnOrder", "ReorderLevel", "Discontinued",
                    "After_Discount", "Year", "Month_Number", "New_Date")
  
  # Alphabetical ordering
  column_names <- column_names %>% 
    sort()
  
  # Expectation
  expect_identical(retrieve_data$fetch_product_orders(file_path = DB_path) %>% 
                     colnames() %>% 
                     sort(), 
                   column_names)
})
