# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  shiny[moduleServer, NS, tagList, observeEvent, renderUI, uiOutput],
  shiny.semantic[action_button, icon, show_modal]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[main_info_modal_logic]
)

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------

#' @export
init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # ----- Application Info Modal -----
    uiOutput(ns("modal")),
    
    # ----- Application Info Modal Button -----
    action_button(input_id = ns("show"), label = "", icon = icon("info circle"), class = "header-help-icon")
  )
}

# -------------------------------------------------------------------------
# ----------------------------- Server Function ---------------------------
# -------------------------------------------------------------------------

#' @export
init_server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      # ----------------------------------
      # ----- Application Info Modal -----
      # ----------------------------------
      observeEvent(input$show, {
        show_modal(id = "modal_UI")
      })
      
      output$modal <- renderUI({
        main_info_modal_logic$build_modal(modal_id = session$ns("modal_UI"))
      })
    }
   )
}
