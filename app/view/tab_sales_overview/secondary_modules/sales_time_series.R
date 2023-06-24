# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`],
  echarts4r[echarts4rOutput, renderEcharts4r],
  shiny[moduleServer, NS, observeEvent, reactive, renderUI, tags, tagList, uiOutput],
  shiny.semantic[action_button, icon, show_modal],
  shinycssloaders[withSpinner]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[sales_time_series_logic, utilities]
)

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------

#' @export
init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # ----- Time Series Modal -----
    uiOutput(ns("modal")),
    
    # ----- Time Series Chart -----
    utilities$custom_box(width = 16,
        title = tags$div(class = "label-container", tags$span(class = "title-span", "REVENUE OVER TIME"), 
                         action_button(input_id = ns("show"), label = "", icon = icon("info circle"), class = "help-icon")),
        ribbon = FALSE, 
        title_side = "top", 
        collapsible = FALSE, 
        
        # Echarts time series
        echarts4rOutput(ns("time_series"), height = "310px") %>% withSpinner(type = 8)
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
      time_series_data <- reactive({
        sales_time_series_logic$filter_data(data = data(),
                                            year = selected_year(),
                                            month = selected_month())
        })
      
      # ----------------------------------------
      # ----- Echarts4r Time Series Output -----
      # ----------------------------------------
      output$time_series <- renderEcharts4r({
        sales_time_series_logic$build_time_series_chart(data = time_series_data(),
                                                        year = selected_year(),
                                                        month = selected_month())
      })
      
      # ----------------------------------
      # ----- Time Series Info Modal -----
      # ----------------------------------
      observeEvent(input$show, {
        show_modal(id = "modal_UI")
      })
      
      output$modal <- renderUI({
        sales_time_series_logic$build_modal(modal_id = session$ns("modal_UI"))
      })
    }
   )
}
