# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`],
  echarts4r[echarts4rOutput, renderEcharts4r],
  shiny[moduleServer, NS, reactive, tagList, 
        div, span],
  shiny.semantic[action_button, icon],
  shinycssloaders[withSpinner]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[employee_time_series_logic, utilities]
)

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------

#' @export
init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # ----- Employee Time Series Chart -----
    utilities$custom_box(width = 16, 
               title = div(class = "label-container", span(class = "title-span", "SALES OVER TIME"), 
                           action_button(input_id = ns("show"), label = "", icon = icon("info circle"), class = "help-icon")), 
               ribbon = FALSE, 
               title_side = "top", 
               collapsible = FALSE, 
               id = ns("box-1"),
               
               # Echarts time series
               echarts4rOutput(ns("employee_time_series"), height = "400px") %>%
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
      time_series_data <- reactive({
        employee_time_series_logic$filter_data(data = data(),
                                               year = selected_year(), 
                                               employee = selected_employee())
      })
      
      # ---------------------------------------------
      # ----- Echart4r Time Series Chart Output -----
      # ---------------------------------------------
      output$employee_time_series <- renderEcharts4r({
        employee_time_series_logic$build_time_series_chart(data = time_series_data(),
                                                           year = selected_year())
      })
    }
   )
}
