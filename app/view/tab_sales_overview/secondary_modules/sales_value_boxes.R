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
  app/logic[sales_value_boxes_logic]
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
        title = "REVENUE", 
        ribbon = FALSE, 
        title_side = "top", 
        collapsible = FALSE, 
        br(), 
        div(class = 'value-box-metric',
            uiOutput(ns("revenue_summary")) %>% withSpinner(type = 8, size = .3, proxy.height = "35px", hide.ui = FALSE),
            span(class = 'value-icon', icon("money bill alternate outline"))),
        hr()), 
    
    # Box for Freight Costs
    box(width = 4, 
        title = "FREIGHT COSTS", 
        ribbon = FALSE, 
        title_side = "top", 
        collapsible = FALSE, 
        br(), 
        div(class = 'value-box-metric',
            uiOutput(ns("freight_summary")) %>% withSpinner(type = 8, size = .3, proxy.height = "35px", hide.ui = FALSE),
            span(class = 'value-icon', icon("money bill alternate"))),
        hr()), 
    
    # Box for Orders
    box(width = 4, 
        title = "ORDERS", 
        ribbon = FALSE, 
        title_side = "top", 
        collapsible = FALSE, 
        br(), 
        div(class = 'value-box-metric', 
            uiOutput(ns("orders_summary")) %>% withSpinner(type = 8, size = .3, proxy.height = "35px", hide.ui = FALSE),
            span(class = 'value-icon', icon("truck"))),
        hr()), 
    
    # Box for Orders on Time
    box(width = 4, 
        title = "ORDERS ON TIME", 
        ribbon = FALSE, 
        title_side = "top", 
        collapsible = FALSE, 
        br(), 
        div(class = 'value-box-metric',
            uiOutput(ns("orders_on_time_summary")) %>% withSpinner(type = 8, size = .3, proxy.height = "35px", hide.ui = FALSE),
            span(class = 'value-icon', icon("hourglass end"))),
        hr()), 
  )
}

# -------------------------------------------------------------------------
# ----------------------------- Server Function ---------------------------
# -------------------------------------------------------------------------

#' @export
init_server <- function(id, data, selected_year, selected_month) {
  moduleServer(
    id,
    function(input, output, session) {
      # -----------------------------------
      # ----- Reactive Data Filtering -----
      # -----------------------------------
      valueBoxValues <- reactive({
        sales_value_boxes_logic$filter_data(data = data(),
                                            year = selected_year(),
                                            month = selected_month())
        })
      
      # -------------------
      # ----- Outputs -----
      # -------------------
      output$revenue_summary <- renderUI({
        span(class = "metric", id = session$ns("revenue_summary"), 
                  valueBoxValues()$Total_Revenue)
      })
      
      output$freight_summary <- renderUI({
        span(class = "metric", id = session$ns("freight_summary"), 
                  valueBoxValues()$Total_Freight)
      })
      
      output$orders_summary <- renderUI({
        span(class = "metric", id = session$ns("orders_summary"), 
                  valueBoxValues()$Total_Orders)
      })
      
      output$orders_on_time_summary <- renderUI({
        span(class = "metric", id = session$ns("orders_on_time_summary"), 
                  valueBoxValues()$Order_On_Time)
      })
    }
   )
}