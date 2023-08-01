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
  app/logic[employee_time_series_logic]
)

# -------------------------------------------------------------------------
# ---------------------------------- Tests --------------------------------
# -------------------------------------------------------------------------

# -------------------------
# ----- filter_data() -----
# -------------------------

test_that("filter_data() returns correctly structured data", {
  test_data <- data.frame(Year = c("2016", "2017", "2019", "2019"),
                          FullName = c("Sam", "Bilbo", "Boromir", "Boromir"),
                          New_Date = c("2016-01-01", "2017-06-01", "2019-02-01",
                                       "2019-03-01"),
                          Revenue = c(1:4))
  
  # Expectation: Returns correct object classes for chart_data
  expect_identical(employee_time_series_logic$filter_data(data = test_data,
                                                      year = "2019",
                                                      employee = "Boromir") %>% 
                 class(),
               c("tbl_df", "tbl", "data.frame"))
  
  # Expectation: Returns correct number of columns
  expect_equal(employee_time_series_logic$filter_data(data = test_data,
                                                      year = "2019",
                                                      employee = "Boromir") %>% 
                 ncol(),
               3)
  
  # Expectation: Returns correct column names
  expect_identical(employee_time_series_logic$filter_data(data = test_data,
                                                      year = "2019",
                                                      employee = "Boromir") %>% 
                 colnames(),
               c("New_Date", "Total_Revenue", "Months"))
})

test_that("filter_data() returns correct values", {
  test_data <- data.frame(Year = c("2016", "2017", "2019", "2019"),
                          FullName = c("Sam", "Bilbo", "Boromir", "Boromir"),
                          New_Date = c("2016-01-01", "2017-06-01", "2019-02-01",
                                       "2019-03-01"),
                          Revenue = c(1:4))
  
  # Expectation: filter_data() can return multiple rows and NOT aggregate when it shouldn't
  expect_equal(employee_time_series_logic$filter_data(data = test_data,
                                                      year = "2019",
                                                      employee = "Boromir"),
               tibble(New_Date = c("2019-02-01", "2019-03-01"),
                          Total_Revenue = c(3, 4),
                          Months = c(1:2)))
})
