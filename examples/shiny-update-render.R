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

  colors <- list(
    "bioenergies" = "#156956",
    "fuel" = "#80549f",
    "coal" = "#a68832",
    "solar" = "#d66b0d",
    "gas" = "#f20809",
    "wind" = "#72cbb7",
    "hydraulic" = "#2672b0",
    "nuclear" = "#e4a701",
    "pumping" = "#0e4269"
  )

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
          list(label = "Production (MW)", stroke = colors[[input$variable]])
        )
      )
    )
  })
}

if (interactive()) {
  shinyApp(ui, server)
}
