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
                        min = -1,
                        max = 12,
                        value = 6),
            sliderInput("mu_2",
                        "Env 2 mu:",
                        min = 0,
                        max = 592,
                        value = 300),
            sliderInput("sigl_1",
                        "Env 1 sigl:",
                        min = 0,
                        max = 1,
                        value = 0.5),
            sliderInput("sigl_2",
                        "Env 2 sigl:",
                        min = 0,
                        max = 200,
                        value = 80),
            sliderInput("sigr_1",
                        "Env 1 sigr:",
                        min = 0,
                        max = 1,
                        value = 0.5),
            sliderInput("sigr_2",
                        "Env 2 sigr:",
                        min = 0,
                        max = 200,
                        value = 80),
            sliderInput("c",
                        "C:",
                        min = -50,
                        max = 50,
                        value =-20),
            sliderInput("pd",
                        "PD:",
                        min = 0,
                        max = 1,
                        value = 0.9)
          ),
          mainPanel(
            htmltools::h2("Virtual Species"),
            shiny::plotOutput("plot"),
            # htmltools::h2("A Random Text"),
            # shiny::tableOutput("text")
            h2("A Random DT"),
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
