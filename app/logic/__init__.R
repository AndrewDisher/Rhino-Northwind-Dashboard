# Logic: application code independent from Shiny.
# https://go.appsilon.com/rhino-project-structure

box::use(
  ./constants,
  ./retrieve_data,
  ./utilities,
  
  ./main_modules/main_info_modal_logic,
  
  ./tab_sales_overview/sales_value_boxes_logic, 
  ./tab_sales_overview/sales_time_series_logic, 
  ./tab_sales_overview/sales_category_bar_chart_logic, 
  ./tab_sales_overview/sales_country_map_logic,
  
  ./tab_sales_employees/employee_value_boxes_logic, 
  ./tab_sales_employees/employee_portrait_logic, 
  ./tab_sales_employees/employee_orders_table_logic, 
  ./tab_sales_employees/employee_performance_logic, 
  ./tab_sales_employees/employee_time_series_logic, 
  
  ./tab_product_inventory/inventory_value_boxes_logic, 
  ./tab_product_inventory/table_of_products_logic, 
  ./tab_product_inventory/inventory_bar_chart_logic,
  ./tab_product_inventory/product_lead_times_logic
)
