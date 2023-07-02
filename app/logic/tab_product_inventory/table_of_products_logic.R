# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`, arrange, case_when, desc, filter, group_by, mutate, row_number, select, summarize],
  DT[datatable],
  echarts4r[e_axis_formatter, e_axis_labels, e_axis_pointer, e_bar, e_charts, 
            e_datazoom, e_loess, e_toolbox_feature, e_tooltip, e_tooltip_pointer_formatter, 
            e_y_axis],
  shiny[tags],
  shiny.semantic[action_button, modal]
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
  data_table <- data %>% 
    datatable(class = "cell-border stripe",
              selection = "single",
              extensions = c('Scroller'),
              escape = FALSE,
              options = list(scrollX = TRUE, 
                             scroller = TRUE, 
                             scrollY = 400))
  
  return(data_table)
}

# ----------------------------------------------------------------
# ----- Function to filter Orders data for modal time series -----
# ----------------------------------------------------------------

#' @export
filter_data_for_modal <- function(data, button_id) {
  # ----- Generic Data Filtering ----- 
  # Acquire product ID
  product_id <- strsplit(button_id, "_")[[1]][2] %>% 
    as.numeric()
  
  # Filter data by product ID
  cleaned_data <- data %>% 
    filter(ProductID == product_id)
  
  # ----- Filtering for Time Series Data -----
  time_series_data <- cleaned_data %>%
    group_by(New_Date) %>%
    summarize(Revenue = sum(After_Discount)) %>% 
    mutate(Months = row_number())
  
  # ----- Acquire Product Name Using ID -----
  product_name <- cleaned_data %>%
    select(ProductName) %>%
    unlist() %>%
    unique()
  
  # ----- Acquire Ranking -----
  product_stats <- data %>%
    group_by(ProductID) %>% 
    summarize(Revenue = sum(After_Discount)) %>%
    arrange(desc(Revenue)) %>% 
    mutate(Ranking = row_number()) %>%
    filter(ProductID == product_id) %>% 
    select(Revenue, Ranking) %>% 
    mutate(Revenue = Revenue %>% 
             formatC(big.mark = ", ", format = "f", digits = 0) %>% 
             paste0("$", .))
  
  # ---- Store Output Values in Named List -----
  return_list <- list(time_series_data = time_series_data, 
                      product_name = product_name,
                      product_lifetime_revenue = product_stats[[1]],
                      product_ranking = product_stats[[2]])
  
  return(return_list)
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
            smooth = TRUE,
            itemStyle = list(color = constants$colors$secondary), 
            emphasis = list(itemStyle = list(color = constants$colors$turquoise, 
                                             borderColor = constants$colors$primary))) %>% 
    e_tooltip(trigger = 'axis', 
              e_tooltip_pointer_formatter("currency", digits = 0), 
              borderColor = constants$colors$primary) %>% 
    e_axis_labels(x = 'Date', y = 'USD') %>% 
    e_y_axis(formatter = e_axis_formatter("currency")) %>% 
    e_datazoom(x_index = 0, type = "slider") %>% 
    e_axis_pointer(label = list(show = FALSE)) %>%
    e_toolbox_feature(feature = "saveAsImage",
                      excludeComponents = list("toolbox", "dataZoom"))
  
  return(chart)
}

# -----------------------------------------
# ----- Function to build table modal -----
# -----------------------------------------

#' @export
build_table_modal <- function(modal_id) {
  modal(
    id = modal_id, 
    header = list(tags$h4(class = "modal-title", "Table of Products")), 
    content = list(
      tags$h4(class = "modal-description-header", "Tips"),
      tags$ul(style = "list-style-type: disc;",
              tags$li(class = "modal-paragraph", "Click the button within the row 
                      that corresponds to the product your are interested in to view
                      more in depth information regarding that product.")
      )
    ), 
    footer = action_button(input_id = "dismiss_modal",
                           label = "Dismiss",
                           class = "ui button positive"),
    settings = list(c("transition", "fly down"))
  )
}
