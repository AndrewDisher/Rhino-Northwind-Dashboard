# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`],
  echarts4r[echarts4rOutput, renderEcharts4r],
  semantic.dashboard[icon],
  shiny[moduleServer, NS, observeEvent, reactive, renderUI, tags, tagList, uiOutput],
  shiny.semantic[action_button, icon, show_modal], 
  shinycssloaders[withSpinner]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[sales_category_bar_chart_logic, utilities]
)

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------

#' @export
init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # ----- Bar Chart Modal -----
    uiOutput(ns("modal")),
    
    # ----- Bar Chart Box -----
    utilities$custom_box(width = 16, 
        # title = "REVENUE BY PRODUCT CATEGORY", 
        title = tags$div(class = "label-container", tags$span(class = "title-span", "REVENUE BY PRODUCT CATEGORY"), 
                         action_button(input_id = ns("show"), label = "", icon = icon("info circle"), class = "help-icon")),
        ribbon = FALSE, 
        title_side = "top", 
        collapsible = FALSE, 
        
        # Echarts bar chart
        echarts4rOutput(ns("bar_chart"), height = "280px") %>% withSpinner(type = 8)
    )
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
      bar_chart_data <- reactive({
        sales_category_bar_chart_logic$filter_data(data = data(), 
                                                   year = selected_year(), 
                                                   month = selected_month())
      })
      
      # --------------------------------------
      # ----- Echarts4r Bar Chart Output -----
      # --------------------------------------
      output$bar_chart <- renderEcharts4r({
        sales_category_bar_chart_logic$build_bar_chart(data = bar_chart_data(), 
                                                 year = selected_year(), 
                                                 month = selected_month())
      })
      
      # --------------------------------
      # ----- Bar Chart Info Modal -----
      # --------------------------------
      observeEvent(input$show, {
        show_modal(id = "modal_UI")
      })
      
      output$modal <- renderUI({
        sales_category_bar_chart_logic$build_modal(modal_id = session$ns("modal_UI"))
      })
    }
   )
}