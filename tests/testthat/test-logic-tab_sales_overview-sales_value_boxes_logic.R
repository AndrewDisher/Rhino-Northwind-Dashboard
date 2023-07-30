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
  app/logic[sales_value_boxes_logic]
)

# -------------------------------------------------------------------------
# ---------------------------------- Tests --------------------------------
# -------------------------------------------------------------------------

# -------------------------
# ----- filter_data() -----
# -------------------------

test_that("filter_data() returns correctly structured data", {
  test_data <- data.frame(Year = c("2016", "2016"),
                          Month_Number = c(1, 12),
                          OrderDate = c("2016-01-04", "2016-12-04"),
                          RequiredDate = c("2016-01-07", "2016-12-14"),
                          ShippedDate = c("2016-01-14", "2016-12-07"),
                          After_Discount = c(3, 4),
                          Freight = c(1, 2)
                          )
  
  # Expectation:  correct object class
  expect_identical(sales_value_boxes_logic$filter_data(data = test_data,
                                                       year = "2016",
                                                       month = 1) %>% 
                     class(),
                   "data.frame")
  
  # Expectation:  correct number of columns
  expect_equal(sales_value_boxes_logic$filter_data(data = test_data,
                                                       year = "2016",
                                                       month = 1) %>% 
                     ncol(),
                   4)
  
  # Expectation:  correct column names
  expect_identical(sales_value_boxes_logic$filter_data(data = test_data,
                                                       year = "2016",
                                                       month = 1) %>% 
                     names(),
                   c("Total_Revenue", "Total_Freight", "Total_Orders" , "Order_On_Time"))
})


test_that("filter_data() returns correct values", {
  test_data <- data.frame(Year = c("2016", "2016"),
                          Month_Number = c(1, 12),
                          OrderDate = c("2016-01-04", "2016-12-04"),
                          RequiredDate = c("2016-01-07", "2016-12-14"),
                          ShippedDate = c("2016-01-14", "2016-12-07"),
                          After_Discount = c(3, 4),
                          Freight = c(1, 2)
                          )
  
  # Expectation: Returns correct values for January 2016 
  expect_equal(sales_value_boxes_logic$filter_data(data = test_data,
                                                       year = "2016",
                                                       month = 1),
                   data.frame(Total_Revenue = c("$ 3"),
                              Total_Freight = c("$ 1"),
                              Total_Orders = c(1),
                              Order_On_Time = c("0 %")))
  
  # Expectation: Returns correct values for 2016 all months (month = 0)
  expect_equal(sales_value_boxes_logic$filter_data(data = test_data,
                                                   year = "2016",
                                                   month = 0),
               data.frame(Total_Revenue = c("$ 7"),
                          Total_Freight = c("$ 3"),
                          Total_Orders = c(2),
                          Order_On_Time = c("50 %")))
})
