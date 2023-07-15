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
  app/logic/utilities
)

# -------------------------------------------------------------------------
# ---------------------------------- Tests --------------------------------
# -------------------------------------------------------------------------

# -------------------------------
# ----- get_month_choices() -----
# -------------------------------
test_that("get_month_choices() returns correct vector data", {
  data <- data.frame(Year = rep(c("2016", "2017", "2018"), each = 5),
                     Month = c("January", "January", "February", "February", "March", 
                               "April", "May", "June", "July", "August", 
                               "September", "October", "November", "December", "December"))
  
  expect_identical(
    names(utilities$get_month_choices(data = data, year = "2017")),
    c("All Months", "April", "May", "June", "July", "August"))
  
  expect_identical(
    names(utilities$get_month_choices(data = data, year = "2016")),
    c("All Months", "January", "February", "March"))
  
  expect_identical(utilities$get_month_choices(data = data, year = "2018"),
                   c("All Months" = 0, "September" = 9, "October" = 10, "November" = 11, "December" = 12))
})
