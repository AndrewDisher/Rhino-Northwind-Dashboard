# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  testthat[...],
  dplyr[`%>%`],
  tibble[tibble]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[sales_time_series_logic]
)

# -------------------------------------------------------------------------
# ---------------------------------- Tests --------------------------------
# -------------------------------------------------------------------------

# -------------------------
# ----- filter_data() -----
# -------------------------

test_that("filter_data() returns correctly structured data", {
  test_data <- data.frame(Year = c("2016", "2016", "2016"),
                          Month_Number = c(1, 12, 12),
                          OrderDate = c("2016-01-04", "2016-12-04", "2016-12-08"),
                          New_Date = c("2016-01-01", "2016-12-01", "2016-12-01"),
                          After_Discount = c(3, 4, 5))
  
  # Expectation: Returns correct object classes for chart_data
  expect_identical(sales_time_series_logic$filter_data(data = test_data,
                                                       year = "2016",
                                                       month = 1) %>% 
                     class(),
                   c("tbl_df", "tbl", "data.frame"))
  
  # Expectation: Returns correct number of columns for chart_data
  expect_equal(sales_time_series_logic$filter_data(data = test_data,
                                                   year = "2016",
                                                   month = 1) %>% 
                 ncol(),
               3)
  
  # Expectation: Returns correct column names for chart_data when month is specified
  expect_identical(sales_time_series_logic$filter_data(data = test_data,
                                                       year = "2016",
                                                       month = 1) %>% 
                     colnames(),
                   c("OrderDate", "Total_Revenue", "Days"))
  
  # Expectation: Returns correct column names for chart_data when NO month is specified
  expect_identical(sales_time_series_logic$filter_data(data = test_data,
                                                       year = "2016",
                                                       month = 0) %>% 
                     colnames(),
                   c("New_Date", "Total_Revenue", "Months"))
  
})

test_that("filter_data() returns correct values", {
  test_data <- data.frame(Year = c("2016", "2016", "2016"),
                          Month_Number = c(1, 12, 12),
                          OrderDate = c("2016-01-04", "2016-12-04", "2016-12-08"),
                          New_Date = c("2016-01-01", "2016-12-01", "2016-12-01"),
                          After_Discount = c(3, 4, 5))
  
  # Expectation: Data should return OrderDate and daily data
  expect_equal(sales_time_series_logic$filter_data(data = test_data,
                                                   year = "2016",
                                                   month = 12),
               tibble(OrderDate = c("2016-12-04", "2016-12-08"),
                      Total_Revenue = c(4, 5), 
                      Days = c(1, 2)))
  
  # Expectation: Data should return New_Date and monthly data
  expect_equal(sales_time_series_logic$filter_data(data = test_data,
                                                   year = "2016",
                                                   month = 0),
               tibble(New_Date = c("2016-01-01", "2016-12-01"),
                      Total_Revenue = c(3, 9), 
                      Months = c(1, 2)))
  
})
