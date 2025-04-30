#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    fluidPage(
      titlePanel("VirtualSpecies"),
      verticalLayout(
        sidebarLayout(
          sidebarPanel(
            sliderInput("mu_1",
                        "Env 1 mu:",
                        min = 0,
                        max = 18,
                        value = 8),
            sliderInput("mu_2",
                        "Env 2 mu:",
                        min = 100,
                        max = 1000,
                        value = 700),
            sliderInput("sigl_1",
                        "Env 1 sigl:",
                        min = 0.1,
                        max = 1,
                        value = 0.9),
            sliderInput("sigl_2",
                        "Env 2 sigl:",
                        min = 1,
                        max = 100,
                        value = 50),
            sliderInput("sigr_1",
                        "Env 1 sigr:",
                        min = 0.1,
                        max = 1,
                        value = 0.5),
            sliderInput("sigr_2",
                        "Env 2 sigr:",
                        min = 1,
                        max = 100,
                        value = 60),
            sliderInput("c",
                        "C:",
                        min = -30,
                        max = 10,
                        value = -10),
            sliderInput("pd",
                        "PD:",
                        min = 0,
                        max = 1,
                        value = 0.9),
            sliderInput("L",
                        "L:",
                        min = -1.1,
                        max = 1.1,
                        value = 0.1),
          ),
          mainPanel(
            htmltools::h2("Virtual Species"),

            fluidRow(
              splitLayout(style = "border: 1px solid silver:", cellWidths = c(300,300),
                          shiny::plotOutput("plot_1"),
                          shiny::plotOutput("plot_2")
              )),
            # htmltools::h2("A Random Text"),
            # shiny::tableOutput("text")
            h2("Ocurrences random points"),
            DT::DTOutput("data_table")

          )


        ),

      )


      #golem::golem_welcome_page() # Remove this line to start building your UI
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "virtualsp"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
