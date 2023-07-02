# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  shiny[conditionalPanel, moduleServer, NS, observe, reactive, renderUI, req, uiOutput, 
        a, br, div, h5, img, span],
  shinyjs[useShinyjs], 
  semantic.dashboard[dashboardBody, dashboardHeader, dashboardPage, dashboardSidebar, menuItem, sidebarMenu, tabItem, tabItems],
  shiny.semantic[icon, selectInput, updateSelectInput]
)


# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[constants, retrieve_data, utilities],
  app/view[tab_product_inventory, tab_sales_overview, tab_sales_employees]
)

# -------------------------------------------------------------------------
# -------------------------------- UI Function ----------------------------
# -------------------------------------------------------------------------

# Set the options for loading `shinycssloaders` spinners
options(spinner.color = constants$colors$primary, spinner.color.background = "#ffffff", spinner.size = .5)

#' @export
ui <- function(id) {
  ns <- NS(id)
  # ------------------
  # ----- HEADER -----
  # ------------------
  header <- dashboardHeader(color = "blue", title = "Northwind Traders", 
                            logo_path = "https://neo4j.com/docs/operations-manual/current/_images/fabric/northwind-logo.jpeg", 
                            logo_align = "left", inverted = TRUE, titleWidth = "")
  # -------------------
  # ----- SIDEBAR -----
  # -------------------
  sidebar <- dashboardSidebar(
    size = "", 
    sidebarMenu(
      
      # ----- Main Menu Items -----
      menuItem(text = "Sales Overview", tabName = "salesOverview", icon = icon("chart pie")),
      menuItem(text = "Sales Employees", tabName = "employees", icon = icon("people group")),
      menuItem(text = "Product Inventory", tabName = "productInventory", icon = icon("warehouse")),

      # ----- Conditional Panel: Group 1 -----
      conditionalPanel(class = "conditional-panels",
                       condition = "input.uisidebar === 'salesOverview' || input.uisidebar === 'employees'",
                       div(id = "conditionalPanel1",
                           br(),
                           selectInput(inputId = ns("yearSelection"),
                                       label = h5("Select a Year", align = "center"),
                                       choices = constants$years,
                                       selected = "2017"))),

      # ----- Conditional Panel: Group 2 -----
      conditionalPanel(class = "conditional-panels",
                       condition = "input.uisidebar === 'salesOverview'",
                       div(id = "conditionalPanel2",
                           br(),
                           uiOutput(outputId = ns("monthSelection")))),

      # ----- Conditional Panel: Group 3 -----
      conditionalPanel(class = "conditional-panels",
                       condition = "input.uisidebar === 'employees'",
                       div(id = "conditionalPanel3",
                           br(),
                           selectInput(inputId = ns("selectionEmployee"),
                                       label = h5("Select a Sales Employee", align = "center"),
                                       choices = retrieve_data$fetch_employees()$names,
                                       selected = "Nancy Davolio"))),
      
      # ----- Author Links -----
      div(id = "author-links",
          a(id = "github-link",
                 href = "https://github.com/AndrewDisher",
                 target = "_blank",
                 img(class = "author-img",
                          src = "https://logos-download.com/wp-content/uploads/2016/09/GitHub_logo.png")),
          div(style = "width: 10px;"),
          a(id = "linkedIn-link",
                 href = "https://www.linkedin.com/in/andrew-disher-8b091b212/",
                 target = "_blank",
                 img(class = "author-img",
                          src = "https://pngimg.com/uploads/linkedIn/linkedIn_PNG16.png")),
          div(style = "width: 15px;"),
          a(id = "Northwind-link",
                 href = "https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/northwind-install",
                 target = "_blank",
                 img(class = "author-img",
                          src = "https://neo4j.com/docs/operations-manual/current/_images/fabric/northwind-logo.jpeg")),
          a(id = "author-website-link",
                 href = "https://www.linkedin.com/in/andrew-disher-8b091b212/",
                 target = "_blank",
                 span(class = "author-img", "Created by Andrew D.")))
    )
  )
  
  # ----------------
  # ----- BODY -----
  # ----------------
  body <- dashboardBody(
    tabItems(
      tabItem(tabName = "salesOverview", tab_sales_overview$init_ui(id = ns("tab_sales_overview"))), 
      tabItem(tabName = "employees", tab_sales_employees$init_ui(id = ns("tab_sales_employees"))), 
      useShinyjs(),
      tabItem(tabName = "productInventory", tab_product_inventory$init_ui(id = ns("tab_product_inventory")))
    )
  )
  
  # -----------------------------
  # ----- COMPOSE DASHBOARD -----
  # -----------------------------
  return(dashboardPage(header = header, 
                       sidebar = sidebar, 
                       body = body)) 
  
}

# ---------------------------
# ----- Server Function -----
# ---------------------------

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # ---------------------------
    # ----- Reactive Inputs -----
    # ---------------------------
    year_selection <- reactive({input$yearSelection})
    month_selection <- reactive({
      req(input$monthSelection) 
      input$monthSelection})
    employee_name <- reactive({input$selectionEmployee})
    
    # ------------------------------------------
    # ----- (Not so) Reactive Data Queries -----
    # ------------------------------------------
    revenue_data <- reactive({retrieve_data$fetch_revenue_data()})
    revenue_data_by_category <- reactive({retrieve_data$fetch_revenue_data_by_category()})
    employees <- reactive({retrieve_data$fetch_employees()$data})
    employee_orders <- reactive({retrieve_data$fetch_employee_orders()})
    products_table <- reactive({retrieve_data$fetch_products_table()})
    product_orders <- reactive({retrieve_data$fetch_product_orders()})
    
    # -------------------------------------------
    # ----- UI Components and Their Updates -----
    # -------------------------------------------
    
    # Server rendering of monthSelection input UI
    output$monthSelection <- renderUI({
      selectInput(inputId = session$ns("monthSelection"),
                  label = h5("Select a Month", align = 'center'),
                  choices = utilities$get_month_choices(data = revenue_data(), year = "2018"),
                  selected = 'All Months')
    })
    
    # Observe event to update monthSelection UI
    observe({
      selected_year <- input$yearSelection

      updateSelectInput(session, "monthSelection",
                        choices = utilities$get_month_choices(data = retrieve_data$fetch_revenue_data(), year = selected_year))
    })
    
    # ----------------------------------------------
    # ----- Initialize Module Server Functions -----
    # ----------------------------------------------
    tab_sales_overview$init_server(id = "tab_sales_overview", 
                                   revenue_data = revenue_data, 
                                   revenue_data_by_category = revenue_data_by_category,
                                   year_selection = year_selection, 
                                   month_selection = month_selection)
    
    tab_sales_employees$init_server(id = "tab_sales_employees", 
                                    employee_orders = employee_orders,
                                    employees = employees,
                                    year_selection = year_selection, 
                                    employee_name = employee_name)
    
    tab_product_inventory$init_server(id = "tab_product_inventory",
                                      products_table = products_table,
                                      product_orders = product_orders)
  })
}
