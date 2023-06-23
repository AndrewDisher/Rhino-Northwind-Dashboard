# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`],
  DT[dataTableOutput, renderDataTable],
  shiny[moduleServer, NS, observeEvent, reactive, renderUI, tagList, uiOutput,
        div, span], 
  shiny.semantic[action_button, icon, show_modal], 
  shinycssloaders[withSpinner]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[employee_orders_table_logic, utilities]
)

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------

#' @export
init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # ----- Orders Table Modal -----
    uiOutput(ns("modal")),
    
    # ----- Orders Data Table -----
    utilities$custom_box(width = 16,
                         title = div(class = "label-container", span(class = "title-span", "ORDER DETAILS"),
                                     action_button(input_id = ns("show"), label = "", icon = icon("info circle"), class = "help-icon")),
                         ribbon = FALSE,
                         title_side = "top",
                         collapsible = FALSE, 
                         id = ns("box-1"), 
               
                         # DT data table output
                         dataTableOutput(outputId = ns("data_table")) %>% withSpinner(type = 8)
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
      orders_table_data <- reactive({
        employee_orders_table_logic$filter_data(data = data(),
                                          year = selected_year(),
                                          employee = selected_employee())
      })
      
      # -----------------------------
      # ----- DT Datable Output -----
      # -----------------------------
      output$data_table <- renderDataTable({
        employee_orders_table_logic$build_orders_table(data = orders_table_data())
      })
      
      # ------------------------------
      # ----- Orders Table Modal -----
      # ------------------------------
      observeEvent(input$show, {
        show_modal(id = "modal_UI")
      })
      
      output$modal <- renderUI({
        employee_orders_table_logic$build_modal(modal_id = session$ns("modal_UI"))
      })
    }
   )
}