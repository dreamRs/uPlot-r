% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/proxy.R
\name{uSetScale}
\alias{uSetScale}
\title{Set the scale of a chart}
\usage{
uSetScale(uplot, min, max, scaleKey = "x")
}
\arguments{
\item{uplot}{Chart created with \code{\link[=uProxy]{uProxy()}}.}

\item{min, max}{Minimum and maximum values to display on the scale.}

\item{scaleKey}{Scale key: "x" or "y".}
}
\value{
An \code{htmlwidget} object of class \code{"uPlot"} or a \code{uProxy} object.
}
\description{
Set the scale of a chart
}
\examples{
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
        width = "100\%"
      )
    )
  )
)

server <- function(input, output, session) {

  output$plot <- renderUPlot({
    uPlot(data = eco2mix[, c("datetime", "consumption")])
  })

  observeEvent(input$scale, {
    uProxy("plot") \%>\%
      uSetScale(min = input$scale[1], max = input$scale[2])
  }, ignoreInit = TRUE)

}

if (interactive())
  shinyApp(ui, server)
}
