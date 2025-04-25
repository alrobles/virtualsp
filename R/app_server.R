#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import ggplot2
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  output$data_table <- DT::renderDT({
    shinipsum::random_DT(5, 5)
  })
  output$plot <- shiny::renderPlot({

    bio1_ts <- terra::unwrap(xsdm::cmcc_cm_bio1)
    bio12_ts <- terra::unwrap(xsdm::cmcc_cm_bio12)
    envData <- list(bio1 = bio1_ts, bio12 = bio12_ts)


    vs_plot <- xsdm::vsp(env_data = envData,
                   param.list = list(mu =   c(input$mu_1, input$mu_2),
                                     sigl = c(input$sigl_1, input$sigl_2),
                                     sigr = c(input$sigr_1, input$sigr_2),
                                     c =  input$c,
                                     pd = input$pd,
                                     L = diag(1, nrow = 2) ))

    ggplot2::ggplot() +
      stars::geom_stars(data = stars::st_as_stars(vs_plot)) +
      #ggplot2::scale_fill_continuous(limits = c(0, 1)) +
      ggplot2::coord_equal() +
      ggplot2::theme_void() +
      ggplot2::scale_fill_viridis_c(limits = c(0, 1)) +
      ggplot2::theme_void() +
      ggplot2::theme(
        legend.position = "bottom"
      )



  })
  output$text <- shiny::renderText({
    shinipsum::random_text(nwords = 50)
  })
}

