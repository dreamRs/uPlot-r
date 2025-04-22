library(shiny)
library(uPlot)

ui <- fluidPage(
  fluidRow(
    column(
      width = 8,
      offset = 2,
      tags$h3("uPlot example"),
      uPlotOutput(outputId = "plot")
    )
  )
)

server <- function(input, output, session) {
  output$plot <- renderUPlot({
    uPlot(
      data = eco2mix[, c("datetime", "consumption")],
      options = list(
        title = "Electricity production (2012 - 2020)"
      )
    ) %>%
      uSeries(
        serie = "datetime",
        label = "Datetime"
      ) %>%
      uSeries(
        serie = "consumption",
        label = "Consumption (MW)",
        stroke = "#0174DF"
      )
  })
}

if (interactive())
  shinyApp(ui, server)
