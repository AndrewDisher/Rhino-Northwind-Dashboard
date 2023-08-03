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
  app/logic[inventory_value_boxes_logic]
)

# -------------------------------------------------------------------------
# ---------------------------------- Tests --------------------------------
# -------------------------------------------------------------------------

# -------------------------
# ----- filter_data() -----
# -------------------------

test_that("filter_data() returns correctly structured data", {
  test_data <- data.frame(UnitsInStock = c(3, 4, 3, 4, 1),
                          UnitsOnOrder = c(0, 2, 1, 2, 0),
                          UnitPrice = c(1:5),
                          ReorderLevel = c(2, 2, 2, 2, 2))
  
  # Expectation: Returns correct object classes
  expect_identical(inventory_value_boxes_logic$filter_data(data = test_data) %>% 
                     class(),
                   "data.frame")
  
  # Expectation: Returns correct number of columns
  expect_equal(inventory_value_boxes_logic$filter_data(data = test_data) %>% 
                 ncol(),
               4)
  
  # Expectation: Returns correct column names
  expect_identical(inventory_value_boxes_logic$filter_data(data = test_data) %>% 
                     colnames(),
                   c("Inventory", "Up_Inventory", "Inventory_Value", "Out_Of_Stock"))
})

test_that("filter_data() returns correct values", {
  test_data <- data.frame(UnitsInStock = c(3, 4, 3, 4, 1),
                          UnitsOnOrder = c(0, 2, 1, 2, 0),
                          UnitPrice = c(1:5),
                          ReorderLevel = c(2, 2, 2, 2, 2))
  
  expect_identical(inventory_value_boxes_logic$filter_data(data = test_data),
                   data.frame(Inventory = c("15 unit(s)"),
                              Up_Inventory = c("5 unit(s)"),
                              Inventory_Value = c("$ 41"),
                              Out_Of_Stock = c("1 item(s)")))
})
