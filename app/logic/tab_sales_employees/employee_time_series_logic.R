# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`, filter, group_by, mutate, summarize, ungroup], 
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
  app/logic/constants
)

# ----------------------------------
# ----- Function to filter data ----
# ----------------------------------

#' @export
filter_data <- function(data, year, employee) {
  # Filter by year and name of employee
  cleaned_data <- data %>% 
    filter(Year == year) %>% 
    filter(FullName == employee)
  
  # Obtain revenue data aggregated according to year
  cleaned_data <- cleaned_data %>%
    group_by(New_Date) %>%
    summarize(Total_Revenue = sum(Revenue)) %>%
    ungroup()
  
  # Create Months column variable; used for loess regression trend line
  cleaned_data <- cleaned_data %>% 
    mutate(Months = 1:nrow(cleaned_data))
    
  return(cleaned_data)
}

# ----------------------------------------------------------
# ----- Function to render echarts4r time series chart -----
# ----------------------------------------------------------

#' @export
build_time_series_chart <- function(data, year) {
  chart <- data %>%
    e_charts(x = New_Date) %>% 
    e_bar(serie = Total_Revenue, name = paste("Sales in", year, sep = " "), 
          itemStyle = list(color = constants$colors$primary), 
          emphasis = list(itemStyle = list(color = constants$colors$secondary))) %>% 
    e_loess(formula = Total_Revenue ~ Months, name = "Trend Line", 
            itemStyle = list(color = constants$colors$secondary), 
            emphasis = list(itemStyle = list(color = constants$colors$turquoise, 
                                             borderColor = constants$colors$primary))) %>%
    e_tooltip(trigger = 'axis', 
              e_tooltip_pointer_formatter("currency", digits = 0), 
              borderColor = constants$colors$primary) %>% 
    e_datazoom(x_index = 0, type = "slider") %>% 
    e_axis_labels(x = 'Date', y = 'USD') %>% 
    e_y_axis(formatter = e_axis_formatter("currency"))%>% 
    e_axis_pointer(label = list(show = FALSE)) %>% 
    e_toolbox_feature(feature = "saveAsImage", 
                      excludeComponents = list("toolbox", "dataZoom"))
  
  return(chart)
}

# -------------------------------------------
# ----- Function to populate info modal -----
# -------------------------------------------

#' @export
build_modal <- function(modal_id) {
  modal(
    id = modal_id, 
    header = list(tags$h4(class = "modal-title", "Employee's Sales Over Time")), 
    content = list(
      tags$h4(class = "modal-description-header", "Tips"),
      tags$ul(style = "list-style-type: disc;",
              tags$li(class = "modal-paragraph", "Hovering over a month displays 
                a tooltip to compare the trend line to the actual sales value. "), 
              tags$li(class = "modal-paragraph", "If the green trend line's values are the same as the
                the actual values, then there is not enough data to produce an informative trend line."),
              tags$li(class = "modal-paragraph", "Try dragging the slider underneathe the chart to isolate a
                period of interest within the year.")
      )
    ), 
    footer = action_button(input_id = "dismiss_modal",
                           label = "Dismiss",
                           class = "ui button positive"),
    settings = list(c("transition", "fly down"))
  )
}
