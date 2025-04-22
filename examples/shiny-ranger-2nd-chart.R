library(shiny)
library(uPlot)

ui <- fluidPage(
  fluidRow(
    column(
      width = 8,
      offset = 2,
      tags$h3("uPlot with ranger (2nd chart) example"),
      uPlotOutput(outputId = "plot"),
      uPlotOutput(outputId = "ranger", height = "70px")
    )
  )
)

server <- function(input, output, session) {
  output$plot <- renderUPlot({
    uPlot(
      data = eco2mix[, c("datetime", "consumption")],
      options = list(
        title = "Electricity production (2012 - 2020)",
        cursor = list(
          drag = list(
            x = TRUE,
            y = FALSE
          ),
          sync = list(
            key = "mysynckey"
          )
        )
      )
    ) %>%
      uSeries(
        name = "datetime",
        label = "Datetime"
      ) %>%
      uSeries(
        name = "consumption",
        label = "Consumption (MW)",
        stroke = "#0174DF"
      )
  })
  output$ranger <- renderUPlot({
    uPlot(
      data = eco2mix[, c("datetime", "consumption")],
      options = list(
        legend = list(show = FALSE),
        cursor = list(
          drag = list(
            setScale = FALSE,
            x = TRUE,
            y = FALSE
          ),
          sync = list(
            key = "mysynckey"
          )
        )
      )
    ) %>%
      uAxesX(show = FALSE) %>%
      uAxesY(
        stroke = "#FFFFFF",
        grid = list(show = FALSE),
        ticks = list(show = FALSE)
      )
  })
}

if (interactive())
  shinyApp(ui, server)
