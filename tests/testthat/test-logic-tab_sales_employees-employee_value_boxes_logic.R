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
  app/logic[employee_value_boxes_logic]
)

# -------------------------------------------------------------------------
# ---------------------------------- Tests --------------------------------
# -------------------------------------------------------------------------

# -------------------------
# ----- filter_data() -----
# -------------------------

test_that("filter_data() returns correctly structured data", {
  test_data <- data.frame(Year = c("2016", "2016", "2017", "2016"),
                          FullName = c("Frodo", "Gandalf", "Morgoth", "Gandalf"),
                          Revenue = c(1:4))
  
  # Expectation: Returns correct object classes for chart_data
  expect_identical(employee_value_boxes_logic$filter_data(data = test_data,
                                                      year = "2017",
                                                      employee = "Morgoth") %>% 
                 class(),
               "data.frame")
  
  # Expectation: Returns correct number of columns
  expect_equal(employee_value_boxes_logic$filter_data(data = test_data,
                                                      year = "2017",
                                                      employee = "Morgoth") %>% 
                 ncol(),
               4)
  
  # Expectation: Returns correct column names
  expect_identical(employee_value_boxes_logic$filter_data(data = test_data,
                                                      year = "2017",
                                                      employee = "Morgoth") %>% 
                 colnames(),
               c("Revenue", "Revenue_Per_Order", "Revenue_Prop", "Orders"))
})

test_that("filter_data() returns correct values", {
  test_data <- data.frame(Year = c("2016", "2016", "2017", "2016"),
                          FullName = c("Frodo", "Gandalf", "Morgoth", "Gandalf"),
                          Revenue = c(1:4))
  
  # Expectation: filter_data returns data correctly when aggregating multiple orders 
  expect_equal(employee_value_boxes_logic$filter_data(data = test_data,
                                                      year = "2016",
                                                      employee = "Gandalf"),
               data.frame(Revenue = c("$ 6"),
                          Revenue_Per_Order = c("$ 3"),
                          Revenue_Prop = c("85.7 %"),
                          Orders = c(2)))
})