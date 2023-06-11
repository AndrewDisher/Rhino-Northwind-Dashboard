# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`],
  echarts4r[echarts4rOutput, renderEcharts4r],
  semantic.dashboard[icon],
  shiny[moduleServer, NS, reactive, tagList], 
  shinycssloaders[withSpinner]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[constants, sales_time_series_logic, utilities]
)

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------

init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    utilities$custom_box(width = 16, 
        title = "REVENUE OVER TIME", 
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

init_server <- function(id, data, selected_year, selected_month) {
  moduleServer(
    id,
    function(input, output, session) {
      # -----------------------------------
      # ----- Reactive Data Filtering -----
      # -----------------------------------
      chart_data <- reactive({
        sales_time_series_logic$filter_data(data = data(),
                                            year = selected_year(),
                                            month = selected_month())
        })
      # ----------------------------------------
      # ----- Echarts4r Time Series Output -----
      # ----------------------------------------
      output$time_series <- renderEcharts4r({
        sales_time_series_logic$time_series_chart(data = chart_data(), 
                                                  year = selected_year(), 
                                                  month = selected_month())
      })
    }
   )
}