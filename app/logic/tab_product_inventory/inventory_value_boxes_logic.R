# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`, case_when, mutate, summarize]
)

# -----------------------------------
# ----- Function to Filter Data -----
# -----------------------------------

#' @export
filter_data <- function(data) {
  # Calculate metrics for value boxes
  cleaned_data <- data %>% 
    summarize(Inventory = sum(UnitsInStock), 
              Up_Inventory = sum(UnitsOnOrder), 
              Inventory_Value = sum(UnitsInStock * UnitPrice), 
              Out_Of_Stock = (case_when((UnitsInStock + UnitsOnOrder) < ReorderLevel ~ 1, 
                                        (UnitsInStock + UnitsOnOrder) >= ReorderLevel ~ 0)) %>% sum())
  
  # Format the calculated values for presentation
  values_to_return <- cleaned_data %>%
    mutate(Inventory = paste(Inventory, "unit(s)"), 
           Up_Inventory = paste(Up_Inventory, "unit(s)"), 
           Inventory_Value = Inventory_Value %>%
             formatC(big.mark = ", ", format = "f", digits = 0) %>%
             paste("$", .), 
           Out_Of_Stock = paste(Out_Of_Stock, "item(s)"))
  
  return(values_to_return)
}
