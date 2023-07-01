# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------
box::use(
  dplyr[`%>%`, filter, group_by, summarize, ungroup], 
  echarts4r[e_charts, e_map, e_toolbox_feature, e_tooltip, e_tooltip_choro_formatter, e_visual_map],
  htmlwidgets[JS], 
  shiny[tags],
  shiny.semantic[action_button, modal]
  )

# -------------------------------------------------------------------------
# -------------------------------- Modules --------------------------------
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
  cleaned_data <- data  %>%
    filter(Year == year)

  # If month is specificed, filter by month too
  if(month != 0) {
    cleaned_data <- cleaned_data %>%
      filter(Month_Number == month)
  }
  
  # Aggregate data by country
  cleaned_data <- cleaned_data %>%
    group_by(Country) %>%
    summarize(Total_Revenue = sum(After_Discount)) %>%
    ungroup()
  
  return(cleaned_data)
}


# -------------------------------------------
# ----- Functions to create country map -----
# -------------------------------------------

#' @export 
build_country_label <- function(visible = FALSE) {
  list(
    show = visible,
    backgroundColor = constants$colors$borderColor,
    borderRadius = 4,
    borderWidth = 1,
    borderColor = constants$colors$primary,
    color = "black",
    padding = c(10, 14),
    formatter = JS("App.mapLabelFormatter"),
    shadowBlur = 12,
    shadowColor = "rgba(0,0,0,0.2)",
    shadowOffsetY = 3
    )
}

#' @export 
build_country_map <- function(data) {
  data %>%
    e_charts(x = Country) %>%
    e_map(Total_Revenue, roam = TRUE, 
          scaleLimit = list(min = 1, max = 8),
          name = "Total Revenue", 
          itemStyle = list(
            areaColor = constants$colors$areaColor,
            borderColor = constants$colors$borderColor, 
            borderWidth = 0.5), 
          emphasis = list(
            label = build_country_label(),
            itemStyle = list(areaColor = constants$colors$secondary)
            ), 
          select = list(
            label = build_country_label(visible = TRUE),
            itemStyle = list(areaColor = constants$colors$secondary)
            ), 
          selectedMode = "multiple") %>%
    e_visual_map(Total_Revenue,
                 inRange = list(color = c(constants$colors$turquoise, 
                                          constants$colors$primary))) %>%
    e_tooltip(
      trigger = "item",
      formatter = e_tooltip_choro_formatter(style = "currency", digits = 0),
      borderWidth = 1,
      borderColor = constants$colors$primary, 
      extraCssText = "box-shadow: 0 3px 12px rgba(0,0,0,0.2);"
      ) %>% 
    e_toolbox_feature(feature = "saveAsImage")
}

# -------------------------------------------
# ----- Function to populate info modal -----
# -------------------------------------------

#' @export 
build_modal <- function(modal_id) {
  modal(
    id = modal_id,
    header = list(tags$h4(class = "modal-title", "Company Revenue by Country")),
    content = list(
      tags$h4(class = "modal-description-header", "Tips"),
      tags$ul(style = "list-style-type: disc;",
              tags$li(class = "modal-paragraph", "Hover over a country to view the aggregated
                      revenue for the selected period."), 
              tags$li(class = "modal-paragraph", "Click a country to affix a label for it's customer revenue; 
                      this allows for convenient comparison of countries. Multiple labels can be 
                      created."), 
              tags$li(class = "modal-paragraph", "Zooming can help comparing countries whose labels
                      overlap."))
    ),
    footer = action_button(input_id = "dismiss_modal",
                           label = "Dismiss",
                           class = "ui button positive"),
    settings = list(c("transition", "fly down"))
  )
}
