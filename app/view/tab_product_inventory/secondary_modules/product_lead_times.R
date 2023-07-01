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
  app/logic[product_lead_times_logic, utilities]
)

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------

#' @export
init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # ----- Lead Times Chart Modal -----
    uiOutput(ns("modal")),
    
    # ----- Lead Times Chart Box -----
    utilities$custom_box(width = 16, 
                         title = div(class = "label-container", 
                                          span(class = "title-span", 
                                                    "AVERAGE DELIVERY LEAD TIME BY COUNTRY"), 
                                          action_button(input_id = ns("show"), 
                                                        label = "", 
                                                        icon = icon("info circle"), 
                                                        class = "help-icon")),
                         ribbon = FALSE, 
                         title_side = "top", 
                         collapsible = FALSE, 
                         
                         # Echarts bar chart
                         echarts4rOutput(ns("lead_time_bar_chart"), height = "280px") %>%
                           withSpinner(type = 8)
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
      lead_times_data <- reactive({
        product_lead_times_logic$format_data(data = data())
      })
      
      # ------------------------------------------------
      # ----- Echarts4r Lead Time Bar Chart Output -----
      # ------------------------------------------------
      output$lead_time_bar_chart <- renderEcharts4r({
        product_lead_times_logic$build_lead_time_chart(data = lead_times_data())
      })
      
      # --------------------------------
      # ----- Bar Chart Info Modal -----
      # --------------------------------
      observeEvent(input$show, {
        show_modal(id = "modal_UI")
      })
      
      output$modal <- renderUI({
        product_lead_times_logic$build_modal(modal_id = session$ns("modal_UI"))
      })
    }
   )
}
