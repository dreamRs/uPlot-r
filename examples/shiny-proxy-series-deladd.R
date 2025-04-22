# Toggle visibility with Proxy --------------------------------------------

library(shiny)
library(uPlot)

ui <- fluidPage(
  tags$h3("uPlot update series with proxy"),
  fluidRow(
    column(
      width = 4,
      textInput(
        inputId = "label",
        label = "Label:",
        value = "Consumption"
      ),
      selectInput(
        inputId = "stroke",
        label = "Stroke color:",
        choices = c("firebrick", "steelblue", "forestgreen", "goldenrod")
      ),
      actionButton("update", "Update plot")
    ),
    column(
      width = 8,
      uPlotOutput(outputId = "plot", height = "500px")
    )
  )
)

server <- function(input, output, session) {

  output$plot <- renderUPlot({
    uPlot(data = eco2mix[1:1500, c(1, 2)]) %>%
      uSeries("consumption", label = "Consumption", stroke = "firebrick")
  })

  observeEvent(input$update, {
    uProxy("plot") %>%
      # First delete existing serie
      uDelSeries(seriesIdx = 2) %>%
      # Then add with new parameters
      uAddSeries(
        seriesIdx = 2,
        label = input$label,
        stroke = input$stroke
      ) %>%
      uRedraw(rebuildPaths = TRUE, recalcAxes = FALSE)
  })

}

if (interactive())
  shinyApp(ui, server)
