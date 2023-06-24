# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`, filter, group_by, mutate, summarize, ungroup], 
  echarts4r[e_charts, e_radar, e_tooltip],
  shiny[tags],
  shiny.semantic[action_button, icon, modal], 
  tidyr[pivot_longer]
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
  # Filter by year
  filt_data <- data %>% 
    filter(Year == year)
  
  # Group by employee name and calculate relevant performance metrics 
  filt_data <- filt_data %>% 
    mutate(Orders_Dummy = 1) %>% 
    group_by(FullName) %>% 
    summarize(`Revenue Generated` = sum(Revenue), 
              Orders = sum(Orders_Dummy), 
              `Avg. Revenue/Order` = sum(Revenue) / sum(Orders_Dummy), 
              `Revenue Contribution` = sum(Revenue) / sum(filt_data$Revenue)) %>% 
    ungroup()
  
  # Scale the data such that each variable is scored on a scale of 0-10
  # Source of logic with explanation (https://www.theanalysisfactor.com/rescaling-variables-to-be-same/)
  filt_data <- filt_data %>% 
    mutate(`Revenue Generated` = (`Revenue Generated` / max(`Revenue Generated`) * 10) %>% 
             round(digits = 1), 
           Orders = (Orders / max(Orders) * 10) %>% 
             round(digits = 1), 
           `Avg. Revenue/Order` = (`Avg. Revenue/Order` / max(`Avg. Revenue/Order`) * 10) %>% 
             round(digits = 1), 
           `Revenue Contribution` = (`Revenue Contribution` / max(`Revenue Contribution`) * 10) %>% 
             round(digits = 1))
  
  # Filter by selected employee's name and then convert data to long format (for echarts4r plotting)
  radar_data <- filt_data %>% 
    filter(FullName == employee) %>% 
    pivot_longer(cols = `Revenue Generated`:`Revenue Contribution`)
  
  # Insert a new line character into Revenue Contribution variable name for cleaner plotting
  # It is the fourth value in the column variable `name`
  radar_data$name[4] <- "Revenue \n Contribution"
  
  return(radar_data)
}

# ---------------------------------------------------
# ----- Function to render echart4r radar chart -----
# ---------------------------------------------------

#' @export
build_radar_chart <- function(data, year, employee) {
  chart <- data %>% 
    e_charts(name) %>%
    e_radar(value, max = 10, name = paste(employee, year, sep = " "), 
            radar = list(axisTick = list(show = TRUE), 
                         axisLabel = list(show = TRUE)), 
            itemStyle = list(color = constants$colors$primary),
            areaStyle = list(color = constants$colors$primary, 
                             opacity = .3),
            emphasis = list(itemStyle = list(color = constants$colors$secondary), 
                            lineStyle = list(color = constants$colors$secondary), 
                            areaStyle = list(color = constants$colors$secondary, 
                                             opacity = .3))) %>% 
    e_tooltip(trigger = "item")
  
  return(chart)
}

# -------------------------------------------
# ----- Function to populate info modal -----
# -------------------------------------------

#' @export
build_modal <- function(modal_id) {
  modal(
    id = modal_id,
    header = list(tags$h4(class = "modal-title", "Employee Performance")),
    content = list(
      tags$h4(class = "modal-description-header", "Description"),
      tags$p(class = "modal-paragraph",
        "Employee performance is rated using four metrics:"), 
      tags$p(class = "modal-paragraph", 
        tags$ul(style = "list-style-type: disc;", 
                tags$li(class = "modal-paragraph", "Revenue Generated"), 
                tags$li(class = "modal-paragraph", "Revenue Contribution"),
                tags$li(class = "modal-paragraph", "Average Revenue per Order"), 
                tags$li(class = "modal-paragraph", "Number of Orders")
        )),
      tags$p(class = "modal-paragraph", 
        "Each of these metrics were scored on a scale of one to ten, and each employee's yearly performance was 
              derived from this scoring method. A score of zero in any category corresponds to one of zero dollars generated, zero 
              dollars per order, zero percent revenue contributed, or zero orders. A score of ten is awarded when achieving the greatest 
              value of all employees in any category.")
    ),
    footer = action_button(input_id = "dismiss_modal",
                           label = "Dismiss",
                           class = "ui button positive"),
    settings = list(c("transition", "fly down"))
  )
}
