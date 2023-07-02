# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`, arrange, filter, group_by, mutate, summarize, ungroup], 
  echarts4r[e_axis_formatter, e_axis_labels, e_bar, e_charts, e_flip_coords, 
            e_grid, e_labels, e_toolbox_feature, e_tooltip, e_x_axis], 
  htmlwidgets[JS],
  shiny[tags],
  shiny.semantic[action_button, modal]
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
  cleaned_data <- data %>% 
    filter(Year == year)
  
  # Check to see if `All Months is selected`
  if(month != 0) {
    cleaned_data <- cleaned_data %>% 
      filter(Month_Number == month)
    
    month_name <- unique(cleaned_data$Month)
  }
  
  # Aggregate data by category for echarts4r bar chart
  cleaned_data <- cleaned_data %>% 
    group_by(Category) %>% 
    summarize(Total_Revenue = sum(After_Discount), 
              Proportion = sum(After_Discount) / sum(cleaned_data$After_Discount)) %>% 
    arrange(Total_Revenue) %>% 
    ungroup()
  
  if(month != 0) {
    return(list(chart_data = cleaned_data, month_name = month_name))
  }
  else {
    return(list(chart_data = cleaned_data))
    }
}

# -------------------------------------------------
# ----- Function to render echart4r bar chart -----
# -------------------------------------------------

#' @export
build_bar_chart <- function(data, year, month) {
  # Determine if `All Months` is selected
  if(month != 0) {
    time_period <- data$month_name
  }
  else {
    time_period <- "All Months"
  }
  
  # Build the bar chart
  chart <- data$chart_data %>% 
    e_charts(x = Category) %>% 
    e_bar(serie = Total_Revenue, name = paste("Revenue", year, time_period, sep = " "),
          bind = Proportion, 
          itemStyle = list(color = constants$colors$primary), 
          emphasis = list(itemStyle = list(color = constants$colors$secondary)), 
          label = list(show = TRUE)) %>%
    e_labels(position = "right",
             formatter = JS("App.barChartFormatter")) %>%
    e_flip_coords() %>% 
    e_tooltip(formatter = JS("App.barChartTooltip")) %>% 
    e_axis_labels(y = 'Category', x = 'USD') %>% 
    e_x_axis(formatter = e_axis_formatter("currency")) %>% 
    e_grid(left = '13%', bottom = '8%') %>% 
    e_toolbox_feature(feature = "saveAsImage")
    
    return(chart)
}

# -------------------------------------------
# ----- Function to populate info modal -----
# -------------------------------------------

#' @export
build_modal <- function(modal_id) {
  modal(
    id = modal_id, 
    header = list(tags$h4(class = "modal-title", "Company Revenue by Product Category")), 
    content = list(
      tags$h4(class = "modal-description-header", "Tips"),
      tags$p(class = "modal-paragraph", 
        tags$ul(style = "list-style-type: disc;", 
                tags$li(class = "modal-paragraph", "The aggregated revenue by product 
                        category appears to the right of the individual bars. The on-hover
                        tooltip shows the percentage of total company revenue for the period
                        that the category of products has contributed to. "), 
                tags$li(class = "modal-paragraph", "The totoal revenue for the time period 
                        can be seen in the value box labeled \" REVENUE\".")
        ))
    ), 
    footer = action_button(input_id = "dismiss_modal",
                           label = "Dismiss",
                           class = "ui button positive"),
    settings = list(c("transition", "fly down"))
  )
}
