library(shiny)
library(uPlot)

ui <- fluidPage(
  fluidRow(
    column(
      width = 8,
      offset = 2,
      tags$h3("uPlot example"),
      selectInput(
        inputId = "variable",
        label = "Energy source:",
        choices = names(eco2mix)[-c(1, 2)]
      ),
      uPlotOutput(outputId = "plot")
    )
  )
)

server <- function(input, output, session) {
  output$plot <- renderUPlot({
    uPlot::uPlot(
      data = list(
        as.numeric(eco2mix$date),
        eco2mix[[input$variable]]
      ),
      options = list(
        title = "Electricity production",
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
