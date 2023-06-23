# Utility functions used in specific places within the app

# ------------------------------
# ----- Libraries/Packages -----
# ------------------------------

box::use(
  dplyr[`%>%`, filter, select],
  glue[glue],
  semantic.dashboard[column, icon],
  shiny[HTML, singleton, tags]
)

# -----------------------------
# ----- get_month_choices -----
# -----------------------------

# DESCRIPTION: Updates the list of month names that are available for selectInput
#              within dashboard sidebar. 

#' @export
get_month_choices <- function(data, year){
  
  months <- c(1:12)
  names(months) <- month.name
  months_choices <- months
  
  choices_names <- data %>% 
    filter(Year == year) %>% 
    select(Month) %>% 
    unique()
  
  months_choices <- months_choices[choices_names[[1]]]
  
  months_choices <- c("All Months" = 0, months_choices)
  
  return(months_choices)
}

# -----------------------
# ------ custom_box -----
# -----------------------

#' @export
custom_box <- function(..., title = NULL, color = "", ribbon = TRUE, title_side = "top right",
                       collapsible = TRUE, width = 8, id = NULL, collapse_icon = "minus",
                       expand_icon = "plus") {
  box_id <- if (FALSE) {
    paste0("box_", paste0(sample(0:9, 30, TRUE), collapse = ""))
  } else {
    id
  }
  title_id <- sub("box_", "title_", box_id)
  label <- if (FALSE) {
    NULL
  } else {
    title_class <- paste("ui", title_side, ifelse(ribbon, "ribbon", "attached"), "label", color)
    minimize_button <- if (collapsible) {
      icon(collapse_icon, style = "cursor: pointer;")
    } else {
      NULL
    }
    tags$div(class = title_class, minimize_button, title)
  }
  icon_selector <- glue("'#{title_id} > .label > .icon'")
  # nolint start: line_length_linter
  js_script <- glue("$('#{box_id}').accordion({{
    selector: {{ trigger: {icon_selector} }},
    onOpening: function() {{ $({icon_selector}).removeClass('{expand_icon}').addClass('{collapse_icon}'); }},
    onClosing: function() {{ $({icon_selector}).removeClass('{collapse_icon}').addClass('{expand_icon}'); }}
  }});")
  # nolint end
  column(width = width,
         tags$div(class = paste("ui segment raised", color),
                  tags$div(id = box_id, class = "ui accordion",
                           tags$div(id = title_id, class = "title", style = "cursor: auto", label),
                           tags$div(class = "content active", tags$div(...))
                           )
                  ),
         if (collapsible) singleton(
           tags$script(HTML(paste0("$(document).ready(function() {", js_script, " })")))
           )
         )
}