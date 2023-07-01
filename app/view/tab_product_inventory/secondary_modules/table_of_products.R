# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`],
  DT[dataTableOutput, renderDataTable],
  echarts4r[echarts4rOutput, renderEcharts4r],
  shiny[moduleServer, NS, observeEvent, reactive, renderUI, req, tagList, uiOutput,
        div, h2, p, span],
  shinyjs[useShinyjs],
  shiny.semantic[action_button, create_modal, icon, modal, show_modal], 
  shinycssloaders[withSpinner]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[table_of_products_logic, utilities]
)

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------

#' @export
init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    utilities$custom_box(width = 12,
                         title = div(class = "label-container",
                                     span(class = "title-span", "TABLE OF PRODUCTS"),
                                     action_button(input_id = ns("info"),
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
      
      # ---------------------------------------------------
      # ----- Reactive Data Filtering for Modal Chart -----
      # ---------------------------------------------------
      modal_time_series_data <- reactive({
        shiny::req(input$button_id)
        
        table_of_products_logic$filter_data_for_modal(data = product_orders(),
                                                      button_id = input$button_id)
      })
      
      # -------------------------------------------
      # ----- Build the Time Series for Modal -----
      # -------------------------------------------
      output$modal_plot <- renderEcharts4r({
        shiny::req(input$button_id)
        
        table_of_products_logic$build_modal_time_series(data = modal_time_series_data())
      })
      
      # --------------------------------------------
      # ----- Build the Details Buttons' Modal -----
      # --------------------------------------------
      observeEvent(input$button_id, {
        create_modal(modal(
          id = session$ns("details_modal"),
          
          header = h2(class = "modal-title", " This is a god damn HEADER!"),
          
          content = list(p(class = "modal-paragraph", ""),
                         echarts4rOutput(session$ns("modal_plot"))),
          
          footer = action_button(input_id = session$ns("dismiss_modal"),
                                label = "Dismiss",
                                class = "ui button positive"), 
          
          settings = list(c("transition", "fly down"))
        ))
      })
    }
   )
}
