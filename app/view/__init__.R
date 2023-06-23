# View: Shiny modules and related code.
# https://go.appsilon.com/rhino-project-structure

box::use(
  ./tab_sales_overview/tab_sales_overview,
  ./tab_sales_overview/secondary_modules/sales_value_boxes,
  ./tab_sales_overview/secondary_modules/sales_time_series, 
  ./tab_sales_overview/secondary_modules/sales_category_bar_chart, 
  ./tab_sales_overview/secondary_modules/sales_country_map, 
  ./tab_sales_employees/tab_sales_employees, 
  ./tab_sales_employees/secondary_modules/employee_value_boxes, 
  ./tab_sales_employees/secondary_modules/employee_portrait, 
  ./tab_sales_employees/secondary_modules/employee_orders_table
)