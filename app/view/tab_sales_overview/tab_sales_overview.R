# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  semantic.dashboard[column],
  shiny[br, fluidRow, moduleServer, NS, tagList], 
  shiny.semantic[grid, grid_template]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/view[sales_value_boxes, sales_time_series, sales_category_bar_chart, 
           sales_country_map]
)

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------
#' @export
init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(sales_value_boxes$init_ui(id = ns("sales_value_boxes"))),
    fluidRow(
      column(width = 8,
             sales_time_series$init_ui(id = ns("sales_time_series")),
             br(),
             sales_category_bar_chart$init_ui(id = ns("sales_category_bar_chart"))),
      column(width = 8, sales_country_map$init_ui(id = ns("sales_country_map")))
    )
  )
}

# -------------------------------------------------------------------------
# ----------------------------- Server Function ---------------------------
# -------------------------------------------------------------------------
#' @export
init_server <- function(id, revenue_data, revenue_data_by_category, year_selection, 
                        month_selection) {
  moduleServer(id,
    function(input, output, session) {
      # ------------------------------------
      # ----- Server Secondary Modules -----
      # ------------------------------------
      sales_value_boxes$init_server(id = "sales_value_boxes", 
                                    data = revenue_data, 
                                    selected_year = year_selection, 
                                    selected_month = month_selection)
      
      sales_time_series$init_server(id = "sales_time_series", 
                                    data = revenue_data, 
                                    selected_year = year_selection, 
                                    selected_month = month_selection)
      
      sales_category_bar_chart$init_server(id = "sales_category_bar_chart",
                                           data = revenue_data_by_category, 
                                           selected_year = year_selection, 
                                           selected_month = month_selection)
      
      sales_country_map$init_server(id = "sales_country_map", 
                                    data = revenue_data, 
                                    selected_year = year_selection, 
                                    selected_month = month_selection)
    }
   )
}
