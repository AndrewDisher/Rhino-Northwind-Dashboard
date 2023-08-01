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
  app/logic[employee_performance_logic]
)

# -------------------------------------------------------------------------
# ---------------------------------- Tests --------------------------------
# -------------------------------------------------------------------------

# -------------------------
# ----- filter_data() -----
# -------------------------

test_that("filter_data() returns correctly structured data", {
  test_data <- data.frame(Year = c("2016", "2016", "2016", "2017"),
                          FullName = c("Morgoth", "Fingolfin", "Fingolfin", "Fingolfin"),
                          Revenue = c(4:1))
  
  # Expectation: Returns correct object classes for
  expect_identical(employee_performance_logic$filter_data(data = test_data,
                                                          year = "2016",
                                                          employee = "Morgoth") %>% 
                     class(),
                   c("tbl_df", "tbl", "data.frame"))
  
  # Expectation: Returns correct number of columns
  expect_equal(employee_performance_logic$filter_data(data = test_data,
                                                      year = "2016",
                                                      employee = "Morgoth") %>% 
                 ncol(),
               3)
  
  # Expectation: Returns correct column names
  expect_identical(employee_performance_logic$filter_data(data = test_data,
                                                          year = "2016",
                                                          employee = "Morgoth") %>% 
                     colnames(),
                   c("FullName", "name", "value"))
})

test_that("filter_data() returns correct values", {
  test_data <- data.frame(Year = c("2016", "2016", "2016", "2017"),
                          FullName = c("Morgoth", "Fingolfin", "Fingolfin", "Fingolfin"),
                          Revenue = c(1:4))
  
  # Expectation: filter_data() is able to calculate business logic correctly
  expect_equal(employee_performance_logic$filter_data(data = test_data,
                                                      year = "2016",
                                                      employee = "Fingolfin"),
               tibble(FullName = c("Fingolfin", "Fingolfin", "Fingolfin", "Fingolfin"),
                      name = c("Revenue Generated", "Orders", "Avg. Revenue/Order",
                               "Revenue \n Contribution"),
                      value = c(10, 10, 6.2, 10)),
               tolerance = 10e-1)
})
