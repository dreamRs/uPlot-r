# Toggle visibility with Proxy --------------------------------------------

library(shiny)
library(uPlot)

ui <- fluidPage(
  tags$h3("uPlot update series with proxy"),
  fluidRow(
    column(
      width = 4,
      checkboxGroupInput(
        inputId = "serie",
        label = "Show series",
        choices = names(eco2mix)[-c(1, 2)],
        selected = "fuel"
      )
    ),
    column(
      width = 8,
      uPlotOutput(outputId = "plot", height = "500px")
    )
  )
)

server <- function(input, output, session) {

  output$plot <- renderUPlot({
    uPlot(data = eco2mix[1:1500, -2]) %>%
      uSeries(serie = "fuel", show = TRUE) %>%
      uSeries(serie = "coal", show = FALSE) %>%
      uSeries(serie = "gas", show = FALSE) %>%
      uSeries(serie = "nuclear", show = FALSE) %>%
      uSeries(serie = "wind", show = FALSE) %>%
      uSeries(serie = "solar", show = FALSE) %>%
      uSeries(serie = "hydraulic", show = FALSE) %>%
      uSeries(serie = "pumping", show = FALSE) %>%
      uSeries(serie = "bioenergies", show = FALSE)
  })

  observeEvent(input$serie, {
    series <- names(eco2mix)[-c(1, 2)]
    for (idx in seq_along(series)) {
      uProxy("plot") %>%
        uSetSeries(
          seriesIdx = idx + 1, # +1 because because first serie is datetime
          show = series[idx] %in% input$serie
        )
    }
  }, ignoreInit = TRUE, ignoreNULL = FALSE)

}

if (interactive())
  shinyApp(ui, server)
