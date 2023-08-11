# Rhino Northwind Dashboard

This repository contains the R, SCSS, JavaScript, data, and other files to generate an R/Shiny dashboard application using the Northwind Traders database. The application is deployed on an AWS EC2 instance here: <a href = "http://ec2-52-21-157-89.compute-1.amazonaws.com:3838/nw-app/" target = "_blank">Rhino Northwind Dashboard</a>.

## R/Shiny and Rhino

The application was built using the Shiny package available in R alongside the [Rhino](https://appsilon.github.io/rhino/) application development framework, developed by [Appsilon](https://appsilon.com/). I decided to use Rhino because of the easy implementation of SCSS and JavaScript the framework provides to seamlessly integrate web development features in R/Shiny. Also, it provides a good set up for testing code with various testing packages, like [testthat](https://testthat.r-lib.org/).

## The Data

The data used was the SQLite Implementation of the Northwind Traders database, found at [https://github.com/jpwhite3/northwind-SQLite3](https://github.com/jpwhite3/northwind-SQLite3).
