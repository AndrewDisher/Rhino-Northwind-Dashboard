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
  app/view[inventory_bar_chart, inventory_value_boxes, product_lead_times, 
           table_of_products]
)

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------

#' @export
init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(width = 4, inventory_value_boxes$init_ui(id = ns("inventory_value_boxes"))),
      column(width = 12, table_of_products$init_ui(id = ns("table_of_products")))
    ), 
    fluidRow(
      column(width = 7, inventory_bar_chart$init_ui(id = ns("inventory_bar_chart"))), 
      column(width = 9, product_lead_times$init_ui(id = ns("product_lead_times")))
    )
  )
}

# -------------------------------------------------------------------------
# ----------------------------- Server Function ---------------------------
# -------------------------------------------------------------------------

#' @export
init_server <- function(id, products_table, product_orders) {
  moduleServer(
    id,
    function(input, output, session) {
      # ------------------------------------
      # ----- Server Secondary Modules -----
      # ------------------------------------
      inventory_value_boxes$init_server(id = "inventory_value_boxes",
                                        data = products_table)
      
      table_of_products$init_server(id = "table_of_products",
                                    products_table = products_table, 
                                    product_orders = product_orders)
      
      inventory_bar_chart$init_server(id = "inventory_bar_chart", 
                                      data = products_table)
      
      product_lead_times$init_server(id = "product_lead_times",
                                     data = product_orders)
    }
   )
}
