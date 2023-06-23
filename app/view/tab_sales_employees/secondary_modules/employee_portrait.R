# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  semantic.dashboard[column],
  shiny[imageOutput, moduleServer, observeEvent, NS, reactive, renderImage, 
        renderUI, tagList, uiOutput, 
        div, h4, p, span],
  shiny.fluent[Separator],
  shiny.semantic[action_button, card, icon, modal, show_modal]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[employee_portrait_logic]
)

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------

#' @export
init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    column(width = 4,
           card(class = "employeeImage", style = "width: 400px;",
                div(class = "modal-container", 
                    uiOutput(ns("employee_name")), 
                    action_button(input_id = ns("show"), label = "", icon = icon("info circle"), class = "info-button")),
                div(class = "image", 
                    imageOutput(ns("employee_photo"), width = '100%', height = 'auto', fill = TRUE)),
                Separator("Hire Info"),
                div(class = "info-container",
                    span(class = "attribute-span", "Hire Date: "),
                    uiOutput(ns("employee_hire_date"))),
                div(class = "info-container", 
                    span(class = "attribute-span", "Region: "),
                    uiOutput(ns("employee_region"))), 
                div(class = "info-container", 
                    span(class = "attribute-span", "Country: "),
                    uiOutput(ns("employee_country"))),
                div(class = "info-container", 
                    span(class = "attribute-span", "City: "),
                    uiOutput(ns("employee_city"))), 
                div(class = "info-container", 
                    span(class = "attribute-span", "Home Phone: "),
                    uiOutput(ns("employee_phone"))), 
                div(class = "info-container", 
                    span(class = "attribute-span", "Title: "),
                    uiOutput(ns("employee_job_title"))), 
                div(class = "info-container", 
                    span(class = "attribute-span", "Reports To: "),
                    uiOutput(ns("reports_to"))), 
                div(class = "info-container", 
                    span(class = "attribute-span", "Title of Courtesy: "),
                    uiOutput(ns("employee_polite_title")))
           ))
  )
}

# -------------------------------------------------------------------------
# ----------------------------- Server Function ---------------------------
# -------------------------------------------------------------------------

#' @export
init_server <- function(id, data, selected_employee) {
  moduleServer(
    id,
    function(input, output, session) {
      # -----------------------------------
      # ----- Reactive Data Filtering -----
      # -----------------------------------
      portrait_elements <- reactive({
        employee_portrait_logic$get_portrait_elements(data = data(), 
                                                      employee = selected_employee())
      })
      
      # -------------------
      # ----- Outputs -----
      # -------------------
      output$employee_name <- renderUI({
        span(class = "name-span", id = session$ns("employee_name"), selected_employee())
      })
      
      output$employee_photo <- renderImage({
        list(src = portrait_elements()$image, contentType = "image/jpeg")
      }, deleteFile = TRUE)
      
      output$employee_hire_date <- renderUI({
        span(class = "info-span", id = session$ns("employee_hire_date"), portrait_elements()$hire_date)
      })
      
      output$employee_country <- renderUI({
        span(class = "info-span", id = session$ns("employee_country"), portrait_elements()$country)
      })
      
      output$employee_region <- renderUI({
        span(class = "info-span", id = session$ns("employee_region"), portrait_elements()$region)
      })
      
      output$employee_city <- renderUI({
        span(class = "info-span", id = session$ns("employee_city"), portrait_elements()$city)
      })
      
      output$employee_phone <- renderUI({
        span(class = "info-span", id = session$ns("employee_phone"), portrait_elements()$phone)
      })
      
      output$employee_job_title <- renderUI({
        span(class = "info-span", id = session$ns("employee_job_title"), portrait_elements()$title)
      })
      
      output$reports_to <- renderUI({
        span(class = "info-span", id = session$ns("reports_to"), portrait_elements()$reports_to)
      })
      
      output$employee_polite_title <- renderUI({
        span(class = "info-span", id = session$ns("employee_polite_title"), portrait_elements()$polite_title)
      })
    }
   )
}