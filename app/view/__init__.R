# View: Shiny modules and related code.
# https://go.appsilon.com/rhino-project-structure

box::use(
  ./main_modules/main_info_modal,
  
  ./tab_sales_overview/tab_sales_overview,
  ./tab_sales_overview/secondary_modules/sales_value_boxes,
  ./tab_sales_overview/secondary_modules/sales_time_series, 
  ./tab_sales_overview/secondary_modules/sales_category_bar_chart, 
  ./tab_sales_overview/secondary_modules/sales_country_map,
  
  ./tab_sales_employees/tab_sales_employees, 
  ./tab_sales_employees/secondary_modules/employee_value_boxes, 
  ./tab_sales_employees/secondary_modules/employee_portrait, 
  ./tab_sales_employees/secondary_modules/employee_orders_table, 
  ./tab_sales_employees/secondary_modules/employee_performance, 
  ./tab_sales_employees/secondary_modules/employee_time_series,
  
  ./tab_product_inventory/tab_product_inventory, 
  ./tab_product_inventory/secondary_modules/inventory_value_boxes,
  ./tab_product_inventory/secondary_modules/table_of_products, 
  ./tab_product_inventory/secondary_modules/inventory_bar_chart,
  ./tab_product_inventory/secondary_modules/product_lead_times
)