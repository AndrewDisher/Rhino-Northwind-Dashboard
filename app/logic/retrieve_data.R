# ------------------------------
# ----- Libraries/Packages -----
# ------------------------------

box::use(
  DBI[dbConnect, dbGetQuery, dbDisconnect],
  dplyr[...],
  lubridate[month],
  RSQLite[SQLite]
)

# --------------------------------------------------------------
# ----- Connect/disconnect to/from the local database file -----
# --------------------------------------------------------------

establish_con <- function(path) {
  con <- dbConnect(
    drv = SQLite(), 
    dbname = path
  )
  return(con)
}

close_con <- function(con) {
  dbDisconnect(conn = con)
}

# --------------------------------------------------------
# ----- Retrieve revenue data for Sales Overview tab -----
# --------------------------------------------------------

#' @export
fetch_revenue_data <- function(file_path = "data/northwind.db") {
  con <- establish_con(path = file_path)
  
  raw_data <- dbGetQuery(conn = con,
                         statement =
                           "SELECT OrderDate,  RequiredDate, ShippedDate,
                            sum(`Order Details`.UnitPrice * Quantity) AS B4_Discount,
                            sum(`Order Details`.UnitPrice * Quantity * (1 - Discount)) AS After_Discount, 
                            ShipCountry as Country, Freight
                            FROM Orders
                            LEFT JOIN `Order Details` USING (OrderID)
                            GROUP BY OrderID, OrderDate;")
  
  close_con(con = con)
  
  cleaned_data <- raw_data %>%
    mutate(OrderDate = as.Date(OrderDate, format = "%Y-%m-%d"),
           RequiredDate = as.Date(RequiredDate, format = "%Y-%m-%d"),
           ShippedDate = as.Date(ShippedDate, format = "%Y-%m-%d"),
           Year = format(OrderDate, "%Y"), 
           Month = format(OrderDate, "%B"), 
           Month_Number = month(OrderDate), 
           Country = case_when(Country == 'USA' ~ 'United States', 
                               Country == 'UK' ~ 'United Kingdom', 
                               TRUE ~ Country), 
           New_Date = paste0(Year, "-", Month_Number, "-", "01") %>%
             as.Date(format = "%Y-%m-%d"))
  
  return(cleaned_data)
}

#' @export
fetch_revenue_data_by_category <- function(file_path = "data/northwind.db") {
  con <- establish_con(path = file_path)
  
  raw_data <- dbGetQuery(conn = con, 
                         statement = 
                           "SELECT OrderDate, CategoryName AS Category, 
                            sum(`Order Details`.UnitPrice * Quantity) AS B4_Discount,
                            sum(`Order Details`.UnitPrice * Quantity * (1 - Discount)) AS After_Discount
                            FROM Orders
                            LEFT JOIN `Order Details` USING (OrderID)
                            LEFT JOIN Products USING (ProductID)
                            LEFT JOIN Categories USING (CategoryID)
                            GROUP BY OrderID, Category, OrderDate;")
  
  close_con(con = con)
  
  cleaned_data <- raw_data %>% 
    mutate(OrderDate = as.Date(OrderDate, format = "%Y-%m-%d"), 
           Year = format(OrderDate, "%Y"), 
           Month = format(OrderDate, "%B"), 
           Month_Number = month(OrderDate))
  
  return(cleaned_data)
}

# ----------------------------------------------------------------
# ----- Retrieve sales representative data for Sales Rep tab -----
# ----------------------------------------------------------------

#' @export
fetch_employees <- function(file_path = "data/northwind.db") {
  con <- establish_con(path = file_path)
  
  raw_data <- dbGetQuery(conn = con, 
                         statement = 
                           "SELECT Photo, (FirstName || ' ' || LastName) as FullName, 
                            Notes, HireDate, Region, Country, HomePhone, City, 
                            TitleOfCourtesy, Title, ReportsTo, EmployeeID
                            FROM Employees;")
  
  close_con(con = con)
  
  output_list <- list(data = raw_data, names = raw_data$FullName)
  
  return(output_list)
}

#' @export
fetch_employee_orders <- function(file_path = "data/northwind.db") {
  con <- establish_con(path = file_path)
  
  raw_data <- dbGetQuery(conn = con, 
                         statement = 
                           "SELECT OrderID, ShipName as Customer, FullName, OrderDate, 
                            RequiredDate, ShippedDate, 
                            sum(`Order Details`.UnitPrice * Quantity * (1 - Discount)) AS Revenue, 
                            Freight, ShipAddress, ShipCity, ShipPostalCode, ShipCountry
                            FROM Orders
                            LEFT JOIN (SELECT EmployeeID, (FirstName || ' ' || LastName) as FullName 
                            		       FROM Employees) USING (EmployeeID)
                            LEFT JOIN `Order Details` USING (OrderID)
                            GROUP BY OrderID, OrderDate;")
  
  close_con(con = con)
  
  cleaned_data <- raw_data %>% 
    mutate(OrderDate = as.Date(OrderDate, format = "%Y-%m-%d"), 
           Year = format(OrderDate, "%Y"), 
           Month_Number = month(OrderDate), 
           New_Date = paste0(Year, "-", Month_Number, "-", "01") %>% as.Date(format = "%Y-%m-%d"))
  
  return(cleaned_data)
}

# ------------------------------------------------------------
# ----- Retrieve products data for Product Inventory tab -----
# ------------------------------------------------------------

#' @export
fetch_products_table <- function(file_path = "data/northwind.db") {
  con <- establish_con(path = file_path)
  
  raw_data <- dbGetQuery(conn = con, 
                         statement = 
                           "SELECT ProductID, ProductName, QuantityPerUnit,
                            Products.UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, 
                            Discontinued, Categories.CategoryID, CategoryName AS Category
                            FROM Products
                            LEFT JOIN Categories USING (CategoryID);")
  
  close_con(con = con)
  
  return(raw_data)
}

#' @export
fetch_product_orders <- function(file_path = "data/northwind.db") {
  con <- establish_con(path = file_path)
  
  raw_data <- dbGetQuery(conn = con, 
                         statement = 
                           "SELECT ProductID, OrderID, CustomerID, OrderDate, ShippedDate, 
                            ShipCountry, ProductName, QuantityPerUnit, Products.UnitPrice,
                            UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued, 
    	                      `Order Details`.UnitPrice * Quantity * (1 - Discount) AS After_Discount
                            FROM Products
                            LEFT JOIN `Order Details` USING (ProductID)
                            LEFT JOIN Orders USING (OrderID)
                            ORDER BY ProductID ASC;")
  
  close_con(con = con)
  
  cleaned_data <- raw_data %>% 
    mutate(OrderDate = as.Date(OrderDate, format = "%Y-%m-%d"), 
           Year = format(OrderDate, "%Y"), 
           Month_Number = month(OrderDate), 
           New_Date = paste0(Year, "-", Month_Number, "-", "01") %>% 
             as.Date(format = "%Y-%m-%d"), 
           ShippedDate = as.Date(ShippedDate, format = "%Y-%m-%d"))
  
  return(cleaned_data)
}
