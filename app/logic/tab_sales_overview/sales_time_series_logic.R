# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`, filter, group_by, mutate, summarize, ungroup],
  echarts4r[e_axis_formatter, e_axis_labels, e_axis_pointer, e_bar, e_charts, 
            e_datazoom, e_loess, e_tooltip, e_tooltip_pointer_formatter, e_y_axis], 
  shiny[tags],
  shiny.semantic[modal]
  )

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic/constants
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
  
  # Determine whether to treat data as monthly or daily data
  if(month != 0) {
    cleaned_data <- cleaned_data %>% 
      group_by(OrderDate) %>% 
      summarize(Total_Revenue = sum(After_Discount)) %>% 
      ungroup() 
  }
  else {
    cleaned_data <- cleaned_data %>% 
      group_by(New_Date) %>% 
      summarize(Total_Revenue = sum(After_Discount)) %>% 
      ungroup()
  }
  
  # Create an column of integers, representing either days or months
  if(month != 0) {
    cleaned_data <- cleaned_data %>% mutate(Days = 1:nrow(cleaned_data))
  }
  else {
    cleaned_data <- cleaned_data %>% mutate(Months = 1:nrow(cleaned_data))
  }
  
  return(cleaned_data)
}

# ------------------------------------------------
# ----- Function to create time series chart -----
# ------------------------------------------------

#' @export
build_time_series_chart <- function(data, year, month) {
  # Compose basic elements of chart (bars. trend line)
  if(month != 0) {
    chart <- data %>%
      e_charts(x = OrderDate) %>% 
      e_bar(serie = Total_Revenue, 
            name = paste("Revenue", year, month.name[month %>% as.numeric()], sep = " "), 
            itemStyle = list(color = constants$colors$primary), 
            emphasis = list(itemStyle = list(color = constants$colors$secondary))) %>% 
      e_loess(formula = Total_Revenue ~ Days, name = "Smoothed Trend Line", 
              itemStyle = list(color = constants$colors$secondary), 
              emphasis = list(itemStyle = list(color = constants$colors$turquoise, 
                                               borderColor = constants$colors$primary)))
  }
  else {
    chart <- data %>%
      e_charts(x = New_Date) %>%
      e_bar(serie = Total_Revenue, name = paste("Revenue", year, "All months", sep = " "), 
            itemStyle = list(color = constants$colors$primary), 
            emphasis = list(itemStyle = list(color = constants$colors$secondary))) %>% 
      e_loess(formula = Total_Revenue ~ Months, name = "Smoothed Trend Line", 
              itemStyle = list(color = constants$colors$secondary), 
              emphasis = list(itemStyle = list(color = constants$colors$turquoise, 
                                               borderColor = constants$colors$primary)))
  }
  
  # Add remaining components (not reliant on year/month selection)
  chart <- chart %>%
    e_tooltip(trigger = 'axis',
              e_tooltip_pointer_formatter("currency", digits = 0),
              borderColor = constants$colors$primary) %>% 
    e_datazoom(x_index = 0, type = "slider") %>% 
    e_axis_labels(x = 'Date', y = 'USD') %>% 
    e_y_axis(formatter = e_axis_formatter("currency")) %>% 
    e_axis_pointer(label = list(show = FALSE))
  
  return(chart)
}

# -------------------------------------------
# ----- Function to populate info modal -----
# -------------------------------------------

#' @export
build_modal <- function(modal_id) {
  modal(
    id = modal_id, 
    header = list(tags$h4(class = "modal-title", "Company Revenue Over Time")), 
    content = list(
      tags$h4(class = "modal-description-header", "Tips"),
      tags$ul(style = "list-style-type: disc;",
        tags$li(class = "modal-paragraph", "Hovering over a day of the month or the month itself displays 
                a tooltip to compare the trend line to the actual revenue value. "), 
        tags$li(class = "modal-paragraph", "If the green trend line's values are the same as the
                the actual values, then there is not enough data to produce an informative trend line."),
        tags$li(class = "modal-paragraph", "Try dragging the slider underneathe the chart to isolate a
                period of interest within the year or month.")
      )
    ), 
    settings = list(c("transition", "fly down"))
  )
}
