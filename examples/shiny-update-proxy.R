library(shiny)
library(uPlot)

ui <- fluidPage(
  tags$h3("uPlot proxy example"),
  fluidRow(
    column(
      width = 6,
      selectInput(
        inputId = "variable1",
        label = "Energy source:",
        choices = names(eco2mix)[-c(1, 2)]
      ),
      uPlotOutput(outputId = "plot1")
    ),
    column(
      width = 6,
      selectInput(
        inputId = "variable2",
        label = "Energy source:",
        choices = names(eco2mix)[-c(1, 2)]
      ),
      uPlotOutput(outputId = "plot2")
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

  output$plot1 <- renderUPlot({
    uPlot::uPlot(
      data = list(
        as.numeric(eco2mix$date),
        eco2mix$fuel
      ),
      options = list(
        title = "Electricity production",
        series = list(
          list(label = "Time"),
          list(label = "Production (MW)", stroke = "blue")
        )
      )
    )
  })

  observeEvent(input$variable1, {
    session$sendCustomMessage(
      type = "uplot-setData",
      message = list(
        id = "plot1",
        data = list(
          as.numeric(eco2mix$date),
          eco2mix[[input$variable1]]
        )
      )
    )
  }, ignoreInit = TRUE)


  output$plot2 <- renderUPlot({
    uPlot::uPlot(
      data = list(
        as.numeric(eco2mix$date),
        eco2mix$fuel
      ),
      options = list(
        title = "Electricity production",
        series = list(
          list(label = "Time"),
          list(label = "Production (MW)", stroke = "blue")
        )
      )
    )
  })

  observeEvent(input$variable2, {
    session$sendCustomMessage(
      type = "uplot-api",
      message = list(
        id = "plot2",
        name = "setData",
        args = list(
          list(
            as.numeric(eco2mix$date),
            eco2mix[[input$variable2]]
          )
        )
      )
    )
  }, ignoreInit = TRUE)

}

if (interactive()) {
  shinyApp(ui, server)
}
