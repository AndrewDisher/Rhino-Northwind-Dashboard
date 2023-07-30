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
  app/logic[sales_country_map_logic]
)

# -------------------------------------------------------------------------
# ---------------------------------- Tests --------------------------------
# -------------------------------------------------------------------------

# -------------------------
# ----- filter_data() -----
# -------------------------

test_that("filter_data() returns correctly structured data", {
  test_data <- data.frame(Country = c("Spain", "Ireland", "Mexico", "Denmark",
                                      "Sweden", "Brazil", "United Kingdom", "China"),
                          After_Discount = c(1:8), 
                          Year = c("2016", "2016", "2016", "2017", "2017", "2018",
                                   "2018", "2018"), 
                          Month_Number = c(1, 2, 2, 5, 7, 8, 12, 12))
  
  # Expectation: Returns correct object classes for chart_data
  expect_identical(sales_country_map_logic$filter_data(data = test_data,
                                                       year = "2016",
                                                       month = 1) %>% 
                     class(),
                   c("tbl_df", "tbl", "data.frame"))
  
  # Expectation: Returns correct number of columns for chart_data
  expect_equal(sales_country_map_logic$filter_data(data = test_data,
                                                   year = "2016",
                                                   month = 1) %>% 
                 ncol(),
               2)
  
  # Expectation: Returns correct column names for chart_data
  expect_identical(sales_country_map_logic$filter_data(data = test_data,
                                                       year = "2016",
                                                       month = 1) %>% 
                     colnames(),
                   c("Country", "Total_Revenue"))
  
})

test_that("filter_data() returns correct values", {
  test_data <- data.frame(Country = c("Spain", "Ireland", "Mexico", "Denmark",
                                      "Sweden", "Brazil", "Brazil", "China"),
                          After_Discount = c(1:8), 
                          Year = c("2016", "2016", "2016", "2017", "2017", "2018",
                                   "2018", "2018"), 
                          Month_Number = c(1, 2, 2, 5, 7, 8, 8, 12))

  # Expectation: Data should be aggregated (by Brazil)
  expect_equal(sales_country_map_logic$filter_data(data = test_data,
                                                   year = "2018",
                                                   month = 8),
               tibble(Country = c("Brazil"),
                      Total_Revenue = c(13)))

  # Expectation: data should not be aggregated for Brazil, and multiple rows returned
  expect_equal(sales_country_map_logic$filter_data(data = test_data,
                                                   year = "2018",
                                                   month = 0),
               tibble(Country = c("Brazil", "China"),
                      Total_Revenue = c(13, 8)))

})
