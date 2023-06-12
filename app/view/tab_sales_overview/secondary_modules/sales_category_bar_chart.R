# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`],
  echarts4r[echarts4rOutput, renderEcharts4r],
  semantic.dashboard[icon],
  shiny[moduleServer, NS, reactive, req, tagList],
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
    utilities$custom_box(width = 16, 
        title = "REVENUE BY PRODUCT CATEGORY", 
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
    }
   )
}