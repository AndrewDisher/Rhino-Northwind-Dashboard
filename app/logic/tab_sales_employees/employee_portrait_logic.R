# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`, filter], 
  magick[image_read, image_resize, image_write]
)

# ------------------------------------------------
# ----- Function to construct employee image -----
# ------------------------------------------------

#' @export
construct_image <- function(image_blob) {
  image_jpeg <- image_blob %>% 
    image_read() %>% 
    image_resize("250x175!") %>% 
    image_write(tempfile(fileext = "jpg"), format = "jpg")
  
  return(image_jpeg)
}

# -------------------------------------------------------
# ----- Function to filter data and return elements -----
# -------------------------------------------------------

#' @export
get_portrait_elements <- function(data, employee) {
  # Filter employees table data by chosen employee
  employee_info <- data %>% 
    filter(FullName == employee)
  
  # Construct employee image
  employee_image <- construct_image(image_blob = employee_info$Photo[[1]])
  
  # Discover who the employee reports to (if anybody)
  if(is.na(employee_info$ReportsTo)) {
    reports_to <- "Nobody" %>% as.vector()
  }
  else {
    reports_to <- data[data$EmployeeID == employee_info$ReportsTo, "FullName"]
  }
  
  # Return named list of portrait elements
  portrait_elements <- list(image = employee_image,
                            notes = employee_info$Notes, 
                            hire_date = employee_info$HireDate, 
                            country = employee_info$Country, 
                            region = employee_info$Region, 
                            city = employee_info$City, 
                            phone = employee_info$HomePhone, 
                            title = employee_info$Title, 
                            reports_to = reports_to, 
                            polite_title = employee_info$TitleOfCourtesy
                            )
  
  return(portrait_elements)
}