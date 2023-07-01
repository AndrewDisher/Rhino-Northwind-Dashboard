# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`, case_when, filter, group_by, mutate, row_number, select, summarize],
  echarts4r[e_axis_formatter, e_axis_labels, e_axis_pointer, e_bar, e_charts, 
            e_datazoom, e_loess, e_tooltip, e_tooltip_pointer_formatter, e_y_axis],
  DT[datatable]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[constants, utilities]
)

# ------------------------------------------
# ----- Function to prepare table data -----
# ------------------------------------------

#' @export
prepare_table_data <- function(data) {
  # Reformat Unit Price and Discontinued columns
  cleaned_data <- data %>% 
    mutate(UnitPrice = paste("$", (UnitPrice %>% format(nsmall = 2))), 
           Discontinued = case_when(Discontinued == 1 ~ "Yes", 
                                    Discontinued == 0 ~ "No"))
  
  # Generate HTML buttons and insert them in a `Details` column
  cleaned_data <- cleaned_data %>% 
    mutate(Details = utilities$create_button(ProductID), 
           .before = 1)
  
  # Select columns to present and reorder them
  cleaned_data <- cleaned_data %>%
    select(ProductName, Details, Category, Discontinued, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel)
  
  return(cleaned_data)
}

# -----------------------------------------
# ----- Function to create data table -----
# -----------------------------------------

#' @export
build_data_table <- function(data) {
  data %>% 
    datatable(class = "cell-border stripe",
              selection = "single",
              extensions = c('Scroller'),
              escape = FALSE,
              options = list(pageLength = 5, 
                             scrollX = TRUE, 
                             scroller = TRUE, 
                             scrollY = 400))
}

# ----------------------------------------------------------------
# ----- Function to filter Orders data for modal time series -----
# ----------------------------------------------------------------

#' @export
filter_data_for_modal <- function(data, button_id) {
  # Acquire product ID
  product_id <- strsplit(button_id, "_")[[1]][2] %>% 
    as.numeric()
  
  # Filter data by product ID
  cleaned_data <- data %>%
    filter(ProductID == product_id) %>%
    group_by(New_Date) %>%
    summarize(Revenue = sum(After_Discount)) %>% 
    mutate(Months = row_number())
  
  return(cleaned_data)
}

# ------------------------------------------------------------------
# ----- Function to build time series chart to appear in modal -----
# ------------------------------------------------------------------

#' @export
build_modal_time_series <- function(data) {
  chart <- data %>%
    e_charts(x = New_Date) %>% 
    e_bar(serie = Revenue, name = "Monthly Sales", 
          itemStyle = list(color = constants$colors$primary), 
          emphasis = list(itemStyle = list(color = constants$colors$secondary, 
                                           borderColor = constants$colors$secondary))) %>% 
    e_loess(formula = Revenue ~ Months, name = "Trend Line", 
            itemStyle = list(color = constants$colors$secondary), 
            emphasis = list(itemStyle = list(color = constants$colors$turquoise, 
                                             borderColor = constants$colors$primary))) %>% 
    e_tooltip(trigger = 'axis', 
              e_tooltip_pointer_formatter("currency", digits = 0), 
              borderColor = constants$colors$primary) %>% 
    e_axis_labels(x = 'Date', y = 'USD') %>% 
    e_y_axis(formatter = e_axis_formatter("currency")) %>% 
    e_datazoom(x_index = 0, type = "slider") %>% 
    e_axis_pointer(label = list(show = FALSE))
  
  return(chart)
}

# -------------------------------------------------------------
# ----- Function to acquire product name for modal header -----
# -------------------------------------------------------------

