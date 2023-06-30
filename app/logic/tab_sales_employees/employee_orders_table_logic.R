# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`, filter, mutate, select], 
  DT[datatable],
  shiny[tags],
  shiny.semantic[action_button, modal]
)

# -----------------------------------
# ----- Function to filter data -----
# -----------------------------------

#' @export
filter_data <- function(data, year, employee) {
  # Filter orders by year and selected employee. Remove extra variables.
  cleaned_data <- data %>%
    filter(Year == year) %>%
    filter(FullName == employee) %>% 
    select(-c(Year, FullName, Month_Number, New_Date))
  
  # Reformat Revenue and Freight columns
  cleaned_data <- cleaned_data %>% 
    mutate(Revenue = Revenue %>% 
             formatC(big.mark = ", ", format = "f", digits = 2) %>% 
             paste("$", .), 
           Freight = Freight %>% 
             formatC(big.mark = ", ", format = "f", digits = 2) %>% 
             paste("$", .))
  
  return(cleaned_data)
}

# ----------------------------------------
# ----- Function to build data table -----
# ----------------------------------------

#' @export
build_orders_table <- function(data) {
  data_table <- data %>% 
    datatable(class = "cell-border stripe", 
              extensions = c("Scroller"), 
              options = list(pageLength = 5, 
                             scrollX = TRUE, 
                             scroller = TRUE, 
                             scrollY = 400))
  
  return(data_table)
}

# -------------------------------------------
# ----- Function to populate info modal -----
# -------------------------------------------

#' @export
build_modal <- function(modal_id) {
  modal(
    id = modal_id, 
    header = list(tags$h4(class = "modal-title", "Orders Data Table")), 
    content = list(
      tags$h4(class = "modal-description-header", "Tips"),
      tags$ul(style = "list-style-type: disc;",
              tags$li(class = "modal-paragraph", 
                      "Try clicking a row within the table to hightlight that row for easy reference"), 
              tags$li(class = "modal-paragraph", 
                      "To search for specific information, trying typing into the search box the ID of an 
                      order, the name of a customer, a date, etc")
      )
    ), 
    footer = action_button(input_id = "dismiss_modal",
                           label = "Dismiss",
                           class = "ui button positive"),
    settings = list(c("transition", "fly down"))
  )
}
