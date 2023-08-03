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
  app/logic[inventory_bar_chart_logic]
)

# -------------------------------------------------------------------------
# ---------------------------------- Tests --------------------------------
# -------------------------------------------------------------------------

# ----------------------------------
# ----- summarize_categories() -----
# ----------------------------------

test_that("summarize_categories() returns correctly structured data", {
  test_data <- data.frame(Category = c("A", "B", "A", "C", "B"),
                          UnitPrice = c(1:5),
                          UnitsInStock = c(3, 4, 3, 4, 1))
  
  # Expectation: Returns correct object classes
  expect_identical(inventory_bar_chart_logic$summarize_categories(data = test_data) %>% 
                 class(),
               c("tbl_df", "tbl", "data.frame"))
  
  # Expectation: Returns correct number of columns
  expect_equal(inventory_bar_chart_logic$summarize_categories(data = test_data) %>% 
                 ncol(),
               3)
  
  # Expectation: Returns correct column names
  expect_identical(inventory_bar_chart_logic$summarize_categories(data = test_data) %>% 
                     colnames(),
                   c("Category", "Value", "Proportion"))
})

test_that("summarize_categories() returns correct values", {
  test_data <- data.frame(Category = c("A", "B", "A", "C", "B"),
                          UnitPrice = c(1:5),
                          UnitsInStock = c(3, 4, 3, 4, 1))
  
  expect_equal(inventory_bar_chart_logic$summarize_categories(data = test_data),
               tibble(Category = c("A", "B", "C"),
                      Value = c(12, 13, 16),
                      Proportion = c(.293, .317, .390)),
               tolerance = 1e-3)
})
