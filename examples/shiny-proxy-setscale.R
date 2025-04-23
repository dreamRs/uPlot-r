# set scale with Proxy ----------------------------------------------------

library(shiny)
library(uPlot)

ui <- fluidPage(
  fluidRow(
    column(
      width = 10,
      offset = 1,
      tags$h3("uPlot set scale with proxy"),
      uPlotOutput(outputId = "plot", height = "500px"),
      sliderInput(
        inputId = "scale",
        label = "Set scale:",
        value = range(eco2mix$datetime),
        min = min(eco2mix$datetime),
        max = max(eco2mix$datetime),
        width = "100%"
      )
    )
  )
)

server <- function(input, output, session) {

  output$plot <- renderUPlot({
    uPlot(data = eco2mix[, c("datetime", "consumption")])
  })

  observeEvent(input$scale, {
    uProxy("plot") %>%
      uSetScale(min = input$scale[1], max = input$scale[2])
  }, ignoreInit = TRUE)

}

if (interactive())
  shinyApp(ui, server)
