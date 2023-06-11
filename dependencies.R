# This file allows packrat (used by rsconnect during deployment) to pick up dependencies.

# Shiny Packages
library(htmlwidgets)
library(rhino)
library(semantic.dashboard)
library(shiny)
library(shinycssloaders)
library(shinyjs)
library(shiny.fluent)
library(shiny.semantic)

# Packages for SQLite database querying 
library(DBI)
library(odbc)
library(RSQL)
library(RSQLite)

# Packages for data viz, etc.
library(DT)
library(echarts4r)
library(magick)

# Packages for Data Manipulation
library(dplyr)
library(lubridate)
library(purrr)
library(tidyr)
library(glue)
