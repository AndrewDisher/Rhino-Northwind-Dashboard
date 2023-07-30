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
  app/logic[sales_category_bar_chart_logic]
)

# -------------------------------------------------------------------------
# ---------------------------------- Tests --------------------------------
# -------------------------------------------------------------------------

# -------------------------
# ----- filter_data() -----
# -------------------------

test_that("filter_data() returns correctly structured data", {
  test_data <- data.frame(OrderDate = c("2016-01-14", "2016-02-21",
                                        "2017-12-14", "2017-12-21"), 
                          Category = c("Apples", "Oranges", "Apples", "Kiwi"),
                          After_Discount = c(1:4), 
                          Year = c("2016", "2016", "2017", "2017"), 
                          Month = c("January", "February", "December", "December"), 
                          Month_Number = c(1, 2, 12, 12))
  
  # Expectation: Returns correct object classes for chart_data
  expect_identical(sales_category_bar_chart_logic$filter_data(data = test_data,
                                                              year = "2016",
                                                              month = 1)$chart_data %>% 
                     class(),
                   c("tbl_df", "tbl", "data.frame"))
  
  # Expectation: Returns correct number of columns for chart_data
  expect_equal(sales_category_bar_chart_logic$filter_data(data = test_data,
                                                          year = "2016",
                                                          month = 1)$chart_data %>% 
                 ncol(),
               3)
  
  # Expectation: Returns correct column names for chart_data
  expect_identical(sales_category_bar_chart_logic$filter_data(data = test_data,
                                                              year = "2016",
                                                              month = 1)$chart_data %>% 
                     colnames(),
                   c("Category", "Total_Revenue", "Proportion"))
  
  
  # Expectation: Returns correct data type for month_name
  expect_identical(sales_category_bar_chart_logic$filter_data(data = test_data,
                                                              year = "2016",
                                                              month = 1)$month_name %>% 
                     typeof(),
                   "character")
  
})

test_that("filter_data() returns correct values", {
  test_data <- data.frame(OrderDate = c("2016-01-14", "2016-02-21",
                                        "2017-12-14", "2017-12-21"), 
                          Category = c("Apples", "Apples", "Oranges", "Kiwi"),
                          After_Discount = c(1:4), 
                          Year = c("2016", "2016", "2017", "2017"), 
                          Month = c("January", "February", "December", "December"), 
                          Month_Number = c(1, 2, 12, 12))
  
  # Expectation: Data should be aggregated by category (Apple)
  expect_equal(sales_category_bar_chart_logic$filter_data(data = test_data,
                                                          year = "2016",
                                                          month = 0)$chart_data,
               tibble(Category = c("Apples"),
                      Total_Revenue = c(3),
                      Proportion = c(1)))
  
  # Expectation: data should not be aggregated, and multiple rows returned
  expect_equal(sales_category_bar_chart_logic$filter_data(data = test_data,
                                                          year = "2017",
                                                          month = 12)$chart_data,
               tibble(Category = c("Oranges", "Kiwi"),
                      Total_Revenue = c(3, 4),
                      Proportion = c(.429, .571)),
               tolerance = 1e-2)
  
})
