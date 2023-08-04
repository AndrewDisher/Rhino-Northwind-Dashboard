# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`, arrange, group_by, summarize],
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

# --------------------------------------------
# ----- Function to summarize categories -----
# --------------------------------------------

#' @export
summarize_categories <- function(data) {
  cleaned_data <- data %>%
    group_by(Category) %>%
    summarize(Value = sum(UnitsInStock * UnitPrice), 
              Proportion = sum(UnitsInStock * UnitPrice)/sum(data$UnitsInStock * data$UnitPrice)) %>% 
    arrange(Value)
  
  return(cleaned_data)
}

# ---------------------------------------
# ----- Function to build bar chart -----
# ---------------------------------------

#' @export
build_bar_chart <- function(data) {
  chart <- data %>% 
    e_charts(x = Category) %>% 
    e_bar(serie = Value, name = "Inventory Value by Product Category", 
          bind = Proportion, 
          itemStyle = list(color = constants$colors$primary), 
          emphasis = list(itemStyle = list(color = constants$colors$secondary))) %>% 
    e_labels(position = "right", 
             formatter = htmlwidgets::JS("App.barChartFormatter")) %>% 
    e_flip_coords() %>% 
    e_tooltip(formatter = htmlwidgets::JS("App.barChartTooltip")) %>% 
    e_axis_labels(y = 'Category', x = 'USD') %>% 
    e_x_axis(formatter = e_axis_formatter("currency")) %>%
    e_grid(left = '23%', bottom = '8%') %>% 
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
    header = list(tags$h4(class = "modal-title", "Inventory Value by Product Category")), 
    content = list(
      tags$h4(class = "modal-description-header", "Tips"),
      tags$p(class = "modal-paragraph", 
             tags$ul(style = "list-style-type: disc;", 
                     tags$li(class = "modal-paragraph", "The inventory value by product 
                        category appears to the right of the individual bars. The on-hover
                        tooltip shows the percentage of total inventory value the selected category
                        contributes."), 
                     tags$li(class = "modal-paragraph", "The total inventory value can be 
                             seen in the value box labeled \"TOTAL INVENTORY VALUE\".")
             ))
    ), 
    footer = action_button(input_id = "dismiss_modal",
                           label = "Dismiss",
                           class = "ui button positive"),
    settings = list(c("transition", "fly down"))
  )
}
