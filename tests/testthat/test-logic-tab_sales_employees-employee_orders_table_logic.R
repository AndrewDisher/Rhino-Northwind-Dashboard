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
  app/logic[employee_orders_table_logic]
)

# -------------------------------------------------------------------------
# ---------------------------------- Tests --------------------------------
# -------------------------------------------------------------------------

# -------------------------
# ----- filter_data() -----
# -------------------------

test_that("filter_data() returns correctly structured data", {
  test_data <- data.frame(OrderID = c(1, 2, 3, 4), 
                          Customer = c("Customer1", "Customer2", "Customer3", "Customer4"), 
                          FullName = c("Sauron", "Aragorn", "Gimli", "Witch-King"), 
                          OrderDate = c("2016-01-02", "2016-07-29", "2016-03-08", "2016-03-17"), 
                          RequiredDate = c("2016-01-04", "2016-07-31", "2016-03-10", "2016-03-19"), 
                          ShippedDate = c("2016-01-03", "2016-07-30", "2016-03-09", "2016-03-18"), 
                          Revenue = c(5:8), 
                          Freight = c(1:4), 
                          ShipAddress = c("Add1", "Add2", "Add3", "Add4"), 
                          ShipCity = c("Mordor", "Gondor", "Moria", "Morgul"),
                          ShipPostalCode = c("code1", "code2", "code3", "code4"),
                          ShipCountry = c("Mordor", "Gondor", "Moria", "Morgul"),
                          Year = c("2016", "2016", "2016", "2016"), 
                          Month_Number = c(1, 7, 3, 3),
                          New_Date = c("2016-01-01", "2016-07-01", "2016-03-01", "2016-03-01"))
  
  # Expectation: Returns correct object classes
  expect_identical(employee_orders_table_logic$filter_data(data = test_data,
                                                           year = "2016",
                                                           employee = "Sauron") %>% 
                     class(),
                   c("data.frame"))
  
  # Expectation: Returns correct number of columns
  expect_equal(employee_orders_table_logic$filter_data(data = test_data,
                                                       year = "2016",
                                                       employee = "Sauron") %>% 
                 ncol(),
               11)
  
  # Expectation: Returns correct column names
  expect_identical(employee_orders_table_logic$filter_data(data = test_data,
                                                           year = "2016",
                                                           employee = "Sauron") %>% 
                     colnames(),
                   c("OrderID", "Customer", "OrderDate", "RequiredDate", 
                     "ShippedDate", "Revenue", "Freight", "ShipAddress", 
                     "ShipCity", "ShipPostalCode", "ShipCountry"))
})


test_that("filter_data() returns correct values", {
  test_data <- data.frame(OrderID = c(1, 2, 3, 4), 
                          Customer = c("Customer1", "Customer2", "Customer3", "Customer4"), 
                          FullName = c("Sauron", "Aragorn", "Gimli", "Witch-King"), 
                          OrderDate = c("2016-01-02", "2016-07-29", "2016-03-08", "2016-03-17"), 
                          RequiredDate = c("2016-01-04", "2016-07-31", "2016-03-10", "2016-03-19"), 
                          ShippedDate = c("2016-01-03", "2016-07-30", "2016-03-09", "2016-03-18"), 
                          Revenue = c(5:8), 
                          Freight = c(1:4), 
                          ShipAddress = c("Add1", "Add2", "Add3", "Add4"), 
                          ShipCity = c("Mordor", "Gondor", "Moria", "Morgul"),
                          ShipPostalCode = c("code1", "code2", "code3", "code4"),
                          ShipCountry = c("Mordor", "Gondor", "Moria", "Morgul"),
                          Year = c("2016", "2016", "2016", "2016"), 
                          Month_Number = c(1, 7, 3, 3),
                          New_Date = c("2016-01-01", "2016-07-01", "2016-03-01", "2016-03-01"))
  
  # Expectation: Value are not changed except for Revenue and Freight, for presentation
  expect_identical(employee_orders_table_logic$filter_data(data = test_data,
                                                           year = "2016", 
                                                           employee = "Gimli"),
                   data.frame(OrderID = c(3), 
                              Customer = c("Customer3"), 
                              OrderDate = c("2016-03-08"), 
                              RequiredDate = c("2016-03-10"), 
                              ShippedDate = c("2016-03-09"), 
                              Revenue = c("$ 7.00"), 
                              Freight = c("$ 3.00"), 
                              ShipAddress = c("Add3"), 
                              ShipCity = c("Moria"),
                              ShipPostalCode = c("code3"),
                              ShipCountry = c("Moria")))
})
