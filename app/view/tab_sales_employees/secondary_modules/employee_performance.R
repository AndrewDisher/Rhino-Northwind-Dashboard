# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`],
  echarts4r[echarts4rOutput, renderEcharts4r],
  shiny[moduleServer, NS, observeEvent, reactive, renderUI, tagList, uiOutput, 
        div, span], 
  shiny.semantic[action_button, icon, show_modal],
  shinycssloaders[withSpinner]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[employee_performance_logic, utilities]
)

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------

#' @export
init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # ----- Employee Performance Modal -----
    uiOutput(ns("modal")),
    
    # ----- Employee Performance Radar Chart -----
    utilities$custom_box(width = 16, 
               title = div(class = "label-container", span(class = "title-span", "EMPLOYEE PERFORMANCE"), 
                           action_button(input_id = ns("show"), label = "", icon = icon("info circle"), class = "help-icon")), 
               ribbon = FALSE, 
               title_side = "top", 
               collapsible = FALSE, 
               id = ns("box-1"),
               
               # Echarts time series
               echarts4rOutput(ns("radar_chart"), height = "400px") %>% 
                 withSpinner(type = 8)
    )
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
      radar_chart_data <- reactive({
        employee_performance_logic$filter_data(data = data(), 
                                               year = selected_year(), 
                                               employee = selected_employee())
      })
      
      # ---------------------------------------
      # ----- Echart4r Radar Chart Output -----
      # ---------------------------------------
      output$radar_chart <- renderEcharts4r({
        employee_performance_logic$build_radar_chart(data = radar_chart_data(), 
                                                     year = selected_year(), 
                                                     employee = selected_employee())
      })
      
      # -----------------------------
      # ----- Radar Chart Modal -----
      # -----------------------------
      observeEvent(input$show, {
        show_modal(id = "modal_UI")
      })
      
      output$modal <- renderUI({
        employee_performance_logic$build_modal(modal_id = session$ns("modal_UI"))
      })
    }
   )
}
