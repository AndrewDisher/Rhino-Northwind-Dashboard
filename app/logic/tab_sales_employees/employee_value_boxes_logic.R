# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`, filter, mutate, summarize]
)

# -----------------------------------
# ----- Function to filter data ----- 
# -----------------------------------

#' @export
filter_data <- function(data, year, employee) {
  # Always filter by year
  data_by_date <- data %>% 
    filter(Year == year)
  
  # Filter by employee
  cleaned_data <- data_by_date %>% 
    filter(FullName == employee)
  
  # Calculate relevant metrics
  values_to_return <- cleaned_data %>% 
    summarize(Revenue = sum(Revenue), 
              Revenue_Per_Order = sum(Revenue) / nrow(cleaned_data), 
              Revenue_Prop = (sum(Revenue) / sum(data_by_date$Revenue) * 100) %>% round(digits = 1), 
              Orders = nrow(cleaned_data))
  
  # Format calculations
  values_to_return <- values_to_return %>% 
    mutate(Revenue = Revenue %>% 
             formatC(big.mark = ", ", format = "f", digits = 0) %>% paste("$", .), 
           Revenue_Per_Order = Revenue_Per_Order %>% 
             formatC(big.mark = ", ", format = "f", digits = 0) %>% paste("$", .), 
           Revenue_Prop = Revenue_Prop %>% 
             paste(., "%"))
  
  return(values_to_return)
}
