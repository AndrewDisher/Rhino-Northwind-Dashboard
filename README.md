# Rhino Northwind Dashboard

This repository contains the R, SCSS, JavaScript, data, and other files to generate an R/Shiny dashboard application using the Northwind Traders database. The application is deployed on an AWS EC2 instance here: <a href = "http://ec2-52-21-157-89.compute-1.amazonaws.com:3838/nw-app/" target = "_blank">Rhino Northwind Dashboard</a>.

## R/Shiny and Rhino

The application was built using the Shiny package available in R alongside the [Rhino](https://appsilon.github.io/rhino/) application development framework, developed by [Appsilon](https://appsilon.com/). I decided to use Rhino because of the easy implementation of SCSS and JavaScript the framework provides to seamlessly integrate web development features in R/Shiny. Also, it provides a good set up for testing code with various testing packages, like [testthat](https://testthat.r-lib.org/).

## Docker

The base image used in the Dockerfile is [rocker/shiny:4.3.0](https://github.com/rocker-org/rocker-versioned2/wiki/shiny_ec168d0acc04).

A pre-built docker image for this project can be found in this [DockerHub repository](https://hub.docker.com/repository/docker/adisher/rhino-shiny-nw-dashboard/general) for easy download.

A Dockerfile is provided here in case you'd like to build the image locally. To do this, run in your terminal the command 

```
docker build -t adisher/rhino-shiny-nw-dashboard:v1 .
```

To run a container from the built image (or after you've downloaded the pre-built image from DockerHub), run the command

```
docker run -d --rm -p 3838:3838 adisher/rhino-shiny-nw-dashboard:v1
```

Shiny natively uses port 3838 and [shiny-server](https://github.com/rstudio/shiny-server), the software used to manage the application, listens on port 3838. So you must include <code>3838:3838</code> in your docker run command. 

After doing so, the application should be available on your local machine at the url <code>localhost:3838/nw-app</code>.

## Dependency Management

This project uses the [renv](https://rstudio.github.io/renv/articles/renv.html) package to manage package dependencies for the app, so the Dockerfile is able to read and download these dependncies when building the Docker image. Base Linux dependencies are also addressed explicitly in the Dockerfile.

## The Data

The data used was the SQLite Implementation of the Northwind Traders database, found at [https://github.com/jpwhite3/northwind-SQLite3](https://github.com/jpwhite3/northwind-SQLite3).
