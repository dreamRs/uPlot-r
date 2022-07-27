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
    uPlot::uPlot(
      data = list(
        as.numeric(eco2mix$date),
        eco2mix$consumption
      ),
      options = list(
        title = "Electricity production (2012 - 2020)",
        series = list(
          list(label = "Time"),
          list(label = "Production (MW)", stroke = "#0174DF")
        )
      )
    )
  })
}

if (interactive()) {
  shinyApp(ui, server)
}
