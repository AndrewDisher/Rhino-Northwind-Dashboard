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
  app/logic[inventory_value_boxes_logic]
)

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------

#' @export
init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tagList(
      
      box(width = 4, 
          title = "INVENTORY", 
          ribbon = FALSE, 
          title_side = "top", 
          collapsible = FALSE, 
          br(), 
          div(class = 'value-box-metric',
              uiOutput(ns('Inventory')) %>%
                withSpinner(type = 8, size = .3, proxy.height = "35px", hide.ui = FALSE),
              span(class = 'value-icon', icon("boxes"))),
          hr()), 
      
      br(),
      
      box(width = 4, 
          title = "UPCOMING INVENTORY", 
          ribbon = FALSE, 
          title_side = "top", 
          collapsible = FALSE, 
          br(), 
          div(class = 'value-box-metric',
              uiOutput(ns('Up_Inventory')) %>%
                withSpinner(type = 8, size = .3, proxy.height = "35px", hide.ui = FALSE),
              span(class = 'value-icon', icon("truck"))),
          hr()), 
      
      br(),
      
      box(width = 4, 
          title = "TOTAL INVENTORY VALUE", 
          ribbon = FALSE, 
          title_side = "top", 
          collapsible = FALSE, 
          br(), 
          div(class = 'value-box-metric',
              uiOutput(ns('Inventory_Value')) %>%
                withSpinner(type = 8, size = .3, proxy.height = "35px", hide.ui = FALSE),
              span(class = 'value-icon', icon("money bill alternate outline"))),
          hr()), 
      
      br(), 
      
      box(width = 4, 
          title = "ITEMS IN NEED OF FILLING", 
          ribbon = FALSE, 
          title_side = "top", 
          collapsible = FALSE, 
          br(), 
          div(class = 'value-box-metric',
              uiOutput(ns('Out_Of_Stock')) %>%
                withSpinner(type = 8, size = .3, proxy.height = "35px", hide.ui = FALSE),
              span(class = 'value-icon', icon("dropbox"))),
          hr())
      
    )
  )
}

# -------------------------------------------------------------------------
# ----------------------------- Server Function ---------------------------
# -------------------------------------------------------------------------

#' @export
init_server <- function(id, data) {
  moduleServer(
    id,
    function(input, output, session) {
      # -----------------------------------
      # ----- Reactive Data Filtering -----
      # -----------------------------------
      value_box_values <- reactive({
        inventory_value_boxes_logic$filter_data(data = data())
      })
      
      # -------------------
      # ----- Outputs -----
      # -------------------
      output$Inventory <- renderUI({
        span(class = "metric", id = session$ns("product_inventory"), 
                  value_box_values()$Inventory)
      })
      
      output$Up_Inventory <- renderUI({
        span(class = "metric", id = session$ns("Up_Inventory"), 
                  value_box_values()$Up_Inventory)
      })
      
      output$Inventory_Value <- renderUI({
        span(class = "metric", id = session$ns("Inventory_Value"), 
                  value_box_values()$Inventory_Value)
      })
      
      output$Out_Of_Stock <- renderUI({
        span(class = "metric", id = session$ns("Out_Of_Stock"), 
                  value_box_values()$Out_Of_Stock)
      })
    }
   )
}
