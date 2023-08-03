# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`, arrange, desc, group_by, mutate, summarize],
  echarts4r[e_axis_labels, e_bar, e_charts, e_grid, e_line, e_mark_line, e_toolbox_feature, e_tooltip, e_x_axis],
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
# ----- Function to format data -----
# -----------------------------------

#' @export
format_data <- function(data) {
  # Calculate average by country
  cleaned_data <- data %>% 
    group_by(ShipCountry) %>% 
    summarize(Lead_Time = (ShippedDate - OrderDate) %>% 
                as.numeric() %>% 
                mean(na.rm = TRUE) %>% 
                round(1)) %>% 
    arrange(desc(Lead_Time))
  
  # Calculate overall average
  cleaned_data <- cleaned_data %>% 
    mutate(Overall_AVG =  (data$ShippedDate - data$OrderDate) %>%
             as.numeric() %>% 
             mean(na.rm = TRUE) %>% 
             round(1))
  
  return(cleaned_data)
}

# -------------------------------------------
# ----- Function to build the bar chart -----
# -------------------------------------------

#' @export
build_lead_time_chart <- function(data) {
  chart <- data %>% 
    e_charts(x = ShipCountry) %>% 
    e_bar(serie = Lead_Time, name = "Lead Time",
          bind = Overall_AVG,
          itemStyle = list(color = constants$colors$primary), 
          emphasis = list(itemStyle = list(color = constants$colors$secondary))) %>%
    e_mark_line(data = list(yAxis = mean(data$Overall_AVG), name = "AVG"),
                silent = TRUE,
                lineStyle = list(color = constants$colors$secondary, 
                                 width = 2,
                                 type = "dashed",
                                 shadowBlur = 4,
                                 shadowColor = constants$colors$primary)) %>% 
    e_tooltip(formatter = JS("App.formatLeadTimeTooltip")) %>% 
    e_axis_labels(y = 'Days', x = 'Country') %>% 
    e_x_axis(axisLabel = list(rotate = '45')) %>% 
    e_grid(left = '8%', bottom = '20%') %>% 
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
    header = list(tags$h4(class = "modal-title", "Average Delivery Lead Time by Country")), 
    content = list(
      tags$h4(class = "modal-description-header", "Tips"),
      tags$p(class = "modal-paragraph", 
             tags$ul(style = "list-style-type: disc;", 
                     tags$li(class = "modal-paragraph", "Compare what countries have above or below average 
                             lead times for their orders using the horizontal average line."), 
                     tags$li(class = "modal-paragraph", "The tooltip conveys the country's lead time, but the overall average
                             is displayed below for convenience.")
             ))
    ), 
    footer = action_button(input_id = "dismiss_modal",
                           label = "Dismiss",
                           class = "ui button positive"),
    settings = list(c("transition", "fly down"))
  )
}
