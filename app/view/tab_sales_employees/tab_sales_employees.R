# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  shiny[fluidRow, moduleServer, NS, tagList], 
  semantic.dashboard[column]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/view[employee_value_boxes, employee_orders_table, employee_performance, 
           employee_portrait]
)

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------

#' @export
init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(employee_value_boxes$init_ui(id = ns("employee_value_boxes"))),
    fluidRow(
      column(width = 4,
             employee_portrait$init_ui(id = ns("employee_portrait"))
             ),
      column(width = 12, 
             employee_orders_table$init_ui(id = ns("employee_orders")))
    ), 
    fluidRow(
      column(width = 6, employee_performance$init_ui(id = ns("employee_performance"))), 
      column(width = 10)
    )
  )
}

# -------------------------------------------------------------------------
# ----------------------------- Server Function ---------------------------
# -------------------------------------------------------------------------

#' @export
init_server <- function(id, employee_orders, employees, year_selection, employee_name) {
  moduleServer(
    id,
    function(input, output, session) {
      # ------------------------------------
      # ----- Server Secondary Modules -----
      # ------------------------------------
      employee_value_boxes$init_server(id = "employee_value_boxes", 
                                       data = employee_orders, 
                                       selected_year = year_selection, 
                                       selected_employee = employee_name)
      
      employee_portrait$init_server(id = "employee_portrait", 
                                    data = employees, 
                                    selected_employee = employee_name)
      
      employee_orders_table$init_server(id = "employee_orders", 
                                  data = employee_orders,
                                  selected_year = year_selection,
                                  selected_employee = employee_name)
      
      employee_performance$init_server(id = "employee_performance", 
                                       data = employee_orders, 
                                       selected_year = year_selection,
                                       selected_employee = employee_name)
      
    }
   )
}