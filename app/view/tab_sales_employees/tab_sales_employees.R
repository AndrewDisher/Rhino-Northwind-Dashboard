# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  shiny[br, fluidRow, moduleServer, NS, tagList], 
  semantic.dashboard[column]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/view[employee_value_boxes]
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
      column(width = 8,
             
             br()
             ),
      column(width = 8)
    )
  )
}

# -------------------------------------------------------------------------
# ----------------------------- Server Function ---------------------------
# -------------------------------------------------------------------------

#' @export
init_server <- function(id, employee_orders, year_selection, employee_name) {
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
      
    }
   )
}