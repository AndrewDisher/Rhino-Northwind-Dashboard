# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`],
  semantic.dashboard[box, icon],
  shiny[moduleServer, NS, reactive, renderUI, tagList, uiOutput, 
        br, div, hr, span],
  shinycssloaders[withSpinner]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[employee_value_boxes_logic]
)

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------

#' @export
init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Box for Revenue
    box(width = 4,
        title = "REVENUE GENERATED",
        ribbon = FALSE,
        title_side = "top",
        collapsible = FALSE,
        br(),
        div(class = 'value-box-metric',
            uiOutput(ns("revenue_summary")) %>% 
              withSpinner(type = 8, size = .3, proxy.height = "35px", hide.ui = FALSE),
            span(class = 'value-icon', icon("money bill alternate outline"))),
        hr()),
    
    # Box for Average Revenue per Order
    box(width = 4,
        title = "AVG. REVENUE/ORDER",
        ribbon = FALSE,
        title_side = "top",
        collapsible = FALSE,
        br(),
        div(class = 'value-box-metric',
            uiOutput(ns("revenue_per_order_summary")) %>% 
              withSpinner(type = 8, size = .3, proxy.height = "35px", hide.ui = FALSE), 
            span(class = 'value-icon', icon("money bill alternate"))),
        hr()), 
    
    # Box for Revenue Contribution Percentage
    box(width = 4,
        title = "% REVENUE CONTRIBUTED",
        ribbon = FALSE,
        title_side = "top",
        collapsible = FALSE,
        br(),
        div(class = 'value-box-metric',
            uiOutput(ns("revenue_prop_summary")) %>% 
              withSpinner(type = 8, size = .3, proxy.height = "35px", hide.ui = FALSE), 
            span(class = 'value-icon', icon("chart pie"))),
        hr()), 
    
    # Box for Number of Order
    box(width = 4,
        title = "ORDERS",
        ribbon = FALSE,
        title_side = "top",
        collapsible = FALSE,
        br(),
        div(class = 'value-box-metric',
            uiOutput(ns("orders_summary")) %>% 
              withSpinner(type = 8, size = .3, proxy.height = "35px", hide.ui = FALSE), 
            span(class = 'value-icon', icon("truck"))),
        hr())
  )
}

# -------------------------------------------------------------------------
# ----------------------------- Server Function ---------------------------
# -------------------------------------------------------------------------

#' @export
init_server <- function(id, data, selected_year, selected_employee) {
  moduleServer(
    id,
    function(input, output, session) {
      # -----------------------------------
      # ----- Reactive Data Filtering -----
      # -----------------------------------
      value_box_values <- reactive({
        employee_value_boxes_logic$filter_data(data = data(),
                                            year = selected_year(),
                                            employee = selected_employee())
      })
      
      # -------------------
      # ----- Outputs -----
      # -------------------
      output$revenue_summary <- renderUI({
        span(class = "metric", id = session$ns("revenue_summary"), 
             value_box_values()$Revenue)
      })
      
      output$revenue_per_order_summary <- renderUI({
        span(class = "metric", id = session$ns("revenue_per_order_summary"), 
             value_box_values()$Revenue_Per_Order)
      })
      
      output$revenue_prop_summary <- renderUI({
        span(class = "metric", id = session$ns("renvenue_prop_summary"),
             value_box_values()$Revenue_Prop)
      })
      
      output$orders_summary <- renderUI({
        span(class = "metric", id = session$ns("renvenue_prop_summary"),
             value_box_values()$Orders)
      })
    }
   )
}
