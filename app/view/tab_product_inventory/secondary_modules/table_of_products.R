# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`],
  DT[dataTableOutput, renderDataTable],
  echarts4r[echarts4rOutput, renderEcharts4r],
  shiny[moduleServer, NS, observeEvent, reactive, renderText, renderUI, req, 
        tagList, textOutput, uiOutput,
        br, div, h2, h4, p, span],
  shinyjs[useShinyjs],
  shiny.semantic[action_button, create_modal, icon, modal, show_modal], 
  shinycssloaders[withSpinner]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[constants, table_of_products_logic, utilities]
)

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------

#' @export
init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # ----- UI Output for Modal -----
    uiOutput(ns("modal")),
    
    # ----- Products Table -----
    utilities$custom_box(width = 12,
                         title = div(class = "label-container",
                                     span(class = "title-span", "TABLE OF PRODUCTS"),
                                     action_button(input_id = ns("show"),
                                                   label = "", 
                                                   icon = icon("info circle"), 
                                                   class = "help-icon")
                                     ),
                         ribbon = FALSE,
                         title_side = "top",
                         collapsible = FALSE, 
                         id = ns("box-1"),
                         
                         useShinyjs(),
                         
                         # DT Data Table
                         dataTableOutput(outputId = ns("data_table")) %>%
                           withSpinner(type = 8)
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
      # ----------------------------------
      # ----- Table Data Preparation -----
      # ----------------------------------
      table_data <- reactive({
        table_of_products_logic$prepare_table_data(data = products_table())
      })
      
      # --------------------------------------
      # ----- Rendering of DT Data Table -----
      # --------------------------------------
      output$data_table <- renderDataTable({
        table_of_products_logic$build_data_table(data = table_data())
      })
      
      # ---------------------------------------------
      # ----- Reactive Data Filtering for Modal -----
      # ---------------------------------------------
      modal_data <- reactive({
        req(input$button_id)
        
        table_of_products_logic$filter_data_for_modal(data = product_orders(),
                                                      button_id = input$button_id)
      })
      
      # -----------------------------------
      # ----- Render the Modal Header -----
      # -----------------------------------
      output$modal_header <- renderText({
        req(input$button_id)
        
        modal_data()$product_name
      })
      
      # -------------------------------------------
      # ----- Build the Time Series for Modal -----
      # -------------------------------------------
      output$modal_plot <- renderEcharts4r({
        req(input$button_id)
        
        table_of_products_logic$build_modal_time_series(data = modal_data()$time_series_data)
      })
      
      # -----------------------------------------------------
      # ----- Render Reactive Product Ranking for Modal -----
      # -----------------------------------------------------
      output$product_ranking <- renderUI({
        req(input$button_id)
        
        span(style = paste0("color: ", constants$colors$secondary, ";", 
                            "font-weight: bold;"), 
             paste0("#", modal_data()$product_ranking))
      })
      
      # --------------------------------------------------------------
      # ----- Render Reactive Product Lifetime Revenue for Modal -----
      # --------------------------------------------------------------
      output$product_lifetime_revenue <- renderUI({
        req(input$button_id)
        
        span(style = paste0("color: ", constants$colors$secondary, ";", 
                            "font-weight: bold;"), 
             modal_data()$product_lifetime_revenue)
      })
      
      # --------------------------------------------
      # ----- Build the Details Buttons' Modal -----
      # --------------------------------------------
      observeEvent(input$button_id, {
        create_modal(modal(
          id = session$ns("details_modal"),
          
          header = h2(class = "modal-title", textOutput(session$ns("modal_header"))),
          
          content = list(h4(class = "modal-description-header", "Sales History"),
                         echarts4rOutput(session$ns("modal_plot")),
                         br(),
                         h4(class = "modal-description-header", "Ranking"), 
                         p(class = "modal-paragraph", 
                           "This product ranks as ",
                           uiOutput(session$ns("product_ranking"), container = span),
                           " among all other products in terms of the company lifetime revenue 
                           it has generated, which totals", 
                           uiOutput(session$ns("product_lifetime_revenue"), container = span),
                           "."
                           )
                         ),
          
          footer = action_button(input_id = session$ns("dismiss_modal"),
                                label = "Dismiss",
                                class = "ui button positive"), 
          
          settings = list(c("transition", "fly down"))
        ))
      })
      
      # -------------------------------
      # ----- Order's Table Modal -----
      # -------------------------------
      observeEvent(input$show, {
        show_modal(id = "table_modal")
      })
      
      output$modal <- renderUI({
        table_of_products_logic$build_table_modal(modal_id = session$ns("table_modal"))
      })
    }
   )
}
