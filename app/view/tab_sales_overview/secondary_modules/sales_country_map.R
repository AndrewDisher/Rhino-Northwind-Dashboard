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
  app/logic[sales_country_map_logic, utilities]
)

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------

#' @export
init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # ----- Country Map Modal -----
    uiOutput(ns("modal")),
    
    # ----- Country Map Box -----
    utilities$custom_box(width = 16, 
        # title = "REVENUE BY COUNTRY",
        title = tags$div(class = "label-container", tags$span(class = "title-span", "REVENUE BY COUNTRY"), 
                         action_button(input_id = ns("show"), label = "", icon = icon("info circle"), class = "help-icon")),
        ribbon = FALSE, 
        title_side = "top", 
        collapsible = FALSE, 
        
        # Echarts map
        echarts4rOutput(ns("country_map"), height = "660px") %>% withSpinner(type = 8)
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
      country_map_data <- reactive({
        sales_country_map_logic$filter_data(data = data(), 
                                            year = selected_year(), 
                                            month = selected_month())
      })
      
      # ----------------------------------------
      # ----- Echarts4r Country Map Output -----
      # ----------------------------------------
      output$country_map <- renderEcharts4r({
        sales_country_map_logic$build_country_map(data = country_map_data())
      })
      
      # ----------------------------------
      # ----- Country Map Info Modal -----
      # ----------------------------------
      observeEvent(input$show, {
        show_modal(id = "modal_UI")
      })
      
      output$modal <- renderUI({
        sales_country_map_logic$build_modal(modal_id = session$ns("modal_UI"))
      })
    }
   )
}