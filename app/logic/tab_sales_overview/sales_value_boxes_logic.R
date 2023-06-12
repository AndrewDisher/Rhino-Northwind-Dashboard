# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`, case_when, filter, mutate, summarize],
  stats[na.omit]
)

# -----------------------------------
# ----- Function to filter data ----- 
# -----------------------------------

#' @export
filter_data <- function(data, year, month) {
  # Always filter by year
  cleaned_data <- data %>% filter(Year == year)
  
  # Check to see if month equals 0 (implying 'All Months' is selected)
  if(month != 0) {
    cleaned_data <- cleaned_data %>% 
      filter(Month_Number == month)
  }
  
  cleaned_data <- cleaned_data %>%
    mutate(On_Time = case_when(ShippedDate > RequiredDate ~ 0,
                               ShippedDate <= RequiredDate ~ 1))
  
  cleaned_data <- cleaned_data %>% 
    summarize(Total_Revenue = round(sum(After_Discount), digits = 0), 
              Total_Freight = round(sum(Freight), digits = 0), 
              Total_Orders = nrow(.),
              Order_On_Time = round(sum(On_Time, na.rm = TRUE) / nrow(na.omit(.)) * 100, digits = 1))
  
  # Format values for presentation
  values_to_return <- cleaned_data %>% 
    mutate(Total_Revenue = Total_Revenue %>%
             formatC(big.mark = ", ", format = "f", digits = 0) %>% paste("$", .), 
           Total_Freight = Total_Freight %>% 
             formatC(big.mark = ", ", format = "f", digits = 0) %>% paste("$", .), 
           Order_On_Time = Order_On_Time %>% 
             paste(., "%"))
  
  return(values_to_return)
}