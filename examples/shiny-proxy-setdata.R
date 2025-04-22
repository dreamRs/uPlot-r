# setData with Proxy ------------------------------------------------------

library(shiny)
library(uPlot)

ui <- fluidPage(
  tags$h3("uPlot set data with proxy"),
  selectInput(
    inputId = "variable",
    label = "Energy source:",
    choices = names(eco2mix)[-c(1, 2)]
  ),
  uPlotOutput(outputId = "plot", height = "500px")
)

server <- function(input, output, session) {

  output$plot <- renderUPlot({
    uPlot(data = eco2mix[, c("datetime", "fuel")]) %>%
      uSeries(serie = "fuel", label = "Production (MW)", stroke = "blue")
  })

  observeEvent(input$variable, {
    uProxy("plot") %>%
      uSetData(eco2mix[, c("datetime", input$variable)])
  }, ignoreInit = TRUE)

}

if (interactive())
  shinyApp(ui, server)
