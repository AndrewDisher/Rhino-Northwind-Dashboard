# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  testthat[...],
  dplyr[`%>%`],
  lubridate[make_difftime],
  tibble[tibble]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[product_lead_times_logic]
)

# -------------------------------------------------------------------------
# ---------------------------------- Tests --------------------------------
# -------------------------------------------------------------------------

# -------------------------
# ----- format_data() -----
# -------------------------

test_that("format_data() returns correctly structured data", {
  test_data <- data.frame(ShipCountry = c("Mordor", "Gondor", "Ithilien", "Ithilien",
                                          "Mordor", "Rohan", "Rohan"),
                          ShippedDate = c("2012-09-20", "2012-06-25", "2012-07-12", 
                                          "2012-08-25", "2012-10-25", "2012-04-20",
                                          "2012-05-13") %>% 
                            as.Date(format = "%Y-%m-%d"),
                          OrderDate = c("2012-09-12", "2012-06-20", "2012-07-10", 
                                        "2012-08-10", "2012-10-18", "2012-04-17",
                                        "2012-05-03") %>% 
                            as.Date(format = "%Y-%m-%d"))
  
  # Expectation: Returns correct object classes
  expect_identical(product_lead_times_logic$format_data(data = test_data) %>% 
                 class(),
               c("tbl_df", "tbl", "data.frame"))
  
  # Expectation: Returns correct number of columns
  expect_equal(product_lead_times_logic$format_data(data = test_data) %>% 
                 ncol(),
               3)
  
  # Expectation: Returns correct column names
  expect_identical(product_lead_times_logic$format_data(data = test_data) %>% 
                 colnames(),
               c("ShipCountry", "Lead_Time", "Overall_AVG"))
})

test_that("format_data() returns correct values", {
  test_data <- data.frame(ShipCountry = c("Mordor", "Gondor", "Ithilien", "Ithilien",
                                          "Mordor", "Rohan", "Rohan"),
                          ShippedDate = c("2012-09-20", "2012-06-25", "2012-07-12", 
                                          "2012-08-25", "2012-10-25", "2012-04-20",
                                          "2012-05-13") %>% 
                            as.Date(format = "%Y-%m-%d"),
                          OrderDate = c("2012-09-12", "2012-06-20", "2012-07-10", 
                                        "2012-08-10", "2012-10-18", "2012-04-17",
                                        "2012-05-03") %>% 
                            as.Date(format = "%Y-%m-%d"))
  
  expect_equal(product_lead_times_logic$format_data(data = test_data),
               tibble(ShipCountry = c("Ithilien", "Mordor", "Rohan", "Gondor"),
                      Lead_Time = c(8.5, 7.5, 6.5, 5),
                      Overall_AVG = c(7.1, 7.1, 7.1, 7.1)))
})
