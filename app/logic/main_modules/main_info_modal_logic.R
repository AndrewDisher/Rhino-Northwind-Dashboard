# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  shiny[a, br, div, h4, img, p, span],
  shiny.semantic[action_button, modal]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

# box::use(
#   
# )

# -------------------------------------------
# ----- Function to populate info modal -----
# -------------------------------------------

#' @export
build_modal <- function(modal_id) {
  modal(
    id = modal_id, 
    header = list(h4(class = "modal-title", "Northwind Traders App")), 
    content = list(
      # -----------------------------
      # ----- About the Project -----
      # -----------------------------
      h4(class = "modal-description-header", "About the Project"),
      p(class = "modal-paragraph", 
        "The Northwind Traders Application is my take on the presentation of Microsoft's
        Northwind Traders data base in a dashboard format. It provides easy to consume 
        information via metrics describing the company's health, the performance of its
        employees, and the status of its inventory to further the goal of ensuring that 
        the company functions efficiently and continues to generate profit."),
      br(),
      # -------------------------------
      # ----- Dataset Description -----
      # -------------------------------
      h4(class = "modal-description-header", "Dataset Description"),
      p(class = "modal-paragraph", 
        "The data set is the" , 
        a(href = "https://github.com/jpwhite3/northwind-SQLite3",
          target = "_blank",
          span(class = "tech-span", "SQLite implementation")), 
        "of the Northwind data base. 
        It contains temporal data spanning 3 years and can be broken down according to month. 
        Data was aggregated by the countries from which the individual orders were placed
        to present a geospatial view of the company's revenue generation. Derived metrics
        include revenue, employee performance rating, inventory value, raw inventory units, 
        and delivery lead time. These metrics are each aggregated and displayed in complimentary
        views to facilitate a holistic evaluation of the company."),
      br(),
      # ------------------------------------------
      # ----- Tech Stack Used in Application -----
      # ------------------------------------------
      h4(class = "modal-description-header", "Technologies Used"),
      div(class = "technology-grid",
          div(class = "left-description", span(style = "font-weight: bold;", "Technology Stack:")),
          div(class = "right-tech-used",
              a(href = "https://www.r-project.org/",
                target = "_blank",
                span(class = "tech-span", "R")), 
              a(href = "https://www.rstudio.com/products/shiny/",
                target = "_blank",
                span(class = "tech-span", "R/Shiny")),
              a(href = "https://developer.mozilla.org/en-US/docs/Web/HTML", 
                target = "_blank",
                span(class = "tech-span", "HTML")),
              a(href = "https://developer.mozilla.org/en-US/docs/Web/JavaScript", 
                target = "_blank",
                span(class = "tech-span", "JavaScript")),
              a(href = "https://developer.mozilla.org/en-US/docs/Web/CSS", 
                target = "_blank",
                span(class = "tech-span", "CSS")),
              a(href = "https://en.wikipedia.org/wiki/SQL", 
                target = "_blank",
                span(class = "tech-span", "SQL")),
              a(href = "https://aws.amazon.com/ec2/", 
                target = "_blank",
                span(class = "tech-span", "AWS EC2")),
              a(href = "https://www.docker.com/", 
                target = "_blank",
                span(class = "tech-span", "Docker"))
              )
          ),
      br(),
      # ---------------------------
      # ----- R Package Links -----
      # ---------------------------
      div(class = "technology-grid",
          div(class = "left-description",
              span(style = "font-weight: bold;", "Notable R Packages:")),
          div(class = "right-tech-used",
              a(href = "https://echarts4r.john-coene.com/",
                target = "_blank",
                span(class = "tech-span", "echarts4r")),
              a(href = "https://rstudio.github.io/renv/articles/renv.html",
                target = "_blank", 
                span(class = "tech-span", "renv")),
              a(href = "https://klmr.me/box/",
                target = "_blank",
                span(class = "tech-span", "box")),
              a(href = "https://testthat.r-lib.org/",
                target = "_blank", 
                span(class = "tech-span", "testthat")),
              a(href = "https://dplyr.tidyverse.org/",
                target = "_blank", 
                span(class = "tech-span", "dplyr")),
              a(href = "https://appsilon.github.io/rhino/",
                target = "_blank", 
                span(class = "tech-span", "rhino")),
              a(href = "https://appsilon.github.io/shiny.semantic/",
                target = "_blank", 
                span(class = "tech-span", "shiny.semantic")),
              a(href = "https://appsilon.github.io/semantic.dashboard/",
                target = "_blank", 
                span(class = "tech-span", "semantic.dashboard"))
              )
          ),
      br(),
      # ------------------------------
      # ----- Author Information -----
      # ------------------------------
      h4(class = "modal-description-header", "About the Author"),
      div(class = "app-info-modal", 
          div(id = "author-message",
              "My name is Andrew Disher and I am a Data Science Master's student at the
          University of Massachusetts Dartmouth. Among other things, I delight in building 
          R Shiny applications that showcase the collective power of R, Shiny, HTML, CSS, and
          a suite of other readily available web technologies, all to better communicate data. You can reach me
          via LinkedIn, and browse some of my other work available on GitHub and my website. Cheers!"),
          a(id = "github-link",
            href = "https://github.com/AndrewDisher",
            target = "_blank",
            img(class = "author-img",
                src = "https://logos-download.com/wp-content/uploads/2016/09/GitHub_logo.png")),
          a(id = "linkedIn-link",
            href = "https://www.linkedin.com/in/andrew-disher-8b091b212/",
            target = "_blank",
            img(class = "author-img",
                src = "https://pngimg.com/uploads/linkedIn/linkedIn_PNG16.png")),
          a(id = "author-website-link",
            href = "https://andrew-disher.netlify.app/",
            target = "_blank",
            img(class = "author-img",
                src = "https://cdn.onlinewebfonts.com/svg/img_1489.png"))
          )
    ), 
    footer = action_button(input_id = "dismiss_modal",
                           label = "Dismiss",
                           class = "ui button positive"),
    settings = list(c("transition", "fly down"))
  )
}