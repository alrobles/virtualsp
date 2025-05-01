#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import ggplot2
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

  bio1_ts <-  terra::rast("inst/extdata/bio1.tif")
  bio12_ts <- terra::rast("inst/extdata/bio12.tif")

  envData <- list(bio1 = bio1_ts, bio12 = bio12_ts)

  bio1_mean_ts <-  terra::rast("inst/extdata/bio1_ts_mean.tif")
  bio12_mean_ts <- terra::rast("inst/extdata/bio12_ts_mean.tif")

  envData_mean <- list(bio1 = bio1_mean_ts, bio12 = bio12_mean_ts)

  vs_plot_data <- reactive({
    xsdm::vsp(env_data = envData,
              param.list = list(mu =   c(input$mu_1, input$mu_2),
                                sigl = c(input$sigl_1, input$sigl_2),
                                sigr = c(input$sigr_1, input$sigr_2),
                                c =  input$c,
                                pd = input$pd,
                                L = lkj::L_matrix(2, input$L) ))

  })

  vs_plot_data_mean <- reactive({
    xsdm::vsp(env_data = envData_mean,
              param.list = list(mu =   c(input$mu_1, input$mu_2),
                                sigl = c(input$sigl_1, input$sigl_2),
                                sigr = c(input$sigr_1, input$sigr_2),
                                c =  input$c,
                                pd = input$pd,
                                L = lkj::L_matrix(2, input$L) ))

  })

  vs_df_data <- reactive({
    vs_plot <- vs_plot_data()
    vs_presence <- terra::app(vs_plot, function(x){
      ifelse(x > 0.5, x, NA)
    })
    df_presence <- terra::spatSample(vs_presence, 50, na.rm = TRUE, xy = TRUE)
    df_absence <-  terra::spatSample(vs_plot, 50, na.rm = TRUE, xy = TRUE)
    names(df_presence) <- c("longitude", "latitude", "probs")
    names(df_absence) <- c("longitude", "latitude", "probs")
    df_presence$presence = rbinom(nrow(df_presence), size = 1,  prob = df_presence$probs)
    df_absence$presence = rbinom(nrow(df_absence), size = 1,  prob = df_absence$probs)
    df <- rbind(df_presence, df_absence)

    #df <- df[df$occurrence == 1, ]
    df
  })

  # Downloadable csv of selected dataset ----
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$dataset, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(vs_df_data(), file, row.names = FALSE)
    }
  )

  output$data_table  <- DT::renderDataTable(
    DT::datatable(
      { vs_df_data() },

      extensions = 'Buttons',

      options = list(
        paging = TRUE,
        searching = TRUE,
        fixedColumns = TRUE,
        autoWidth = TRUE,
        ordering = TRUE,
        dom = 'tB',
        buttons = c('copy', 'csv', 'excel')
      ),

      class = "display"
    ))




  output$plot_1 <- shiny::renderPlot({
    vs_plot <- vs_plot_data()
    vs_df <- vs_df_data()

    df_presence <- vs_df[vs_df$occurrence == 1, ]
    df_absence <- vs_df[vs_df$occurrence != 1, ]

    vs_presence_pts <- terra::vect(df_presence, geom = c("longitude", "latitude"))
    vs_absence_pts <- terra::vect(df_absence, geom = c("longitude", "latitude"))

    terra::plot(vs_plot, range = c(0.1, 1))
    terra::points(vs_presence_pts, col = "red", cex = 0.2)
    terra::points(vs_absence_pts, col = "black", cex = 0.2)


  })

  output$plot_2 <- shiny::renderPlot({
    vs_plot_mean <- vs_plot_data_mean()
    vs_df <- vs_df_data()

    df_presence <- vs_df[vs_df$occurrence == 1, ]
    df_absence <- vs_df[vs_df$occurrence != 1, ]

    vs_presence_pts <- terra::vect(df_presence, geom = c("longitude", "latitude"))
    vs_absence_pts <- terra::vect(df_absence, geom = c("longitude", "latitude"))

    terra::plot(vs_plot_mean, range = c(0.1, 1))
    terra::points(vs_presence_pts, col = "red", cex = 0.2)
    terra::points(vs_absence_pts, col = "black", cex = 0.2)


  })
}

