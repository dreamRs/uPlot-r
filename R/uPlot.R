#' Fast, memory-efficient Canvas 2D-based charts
#'
#' <Add Description>
#'
#' @importFrom htmlwidgets createWidget sizingPolicy
#'
#' @export
uPlot <- function(data, options, width = NULL, height = NULL, elementId = NULL) {

  x <- list(
    data = data,
    options = options
  )

  htmlwidgets::createWidget(
    name = "uPlot",
    x = x,
    width = width,
    height = height,
    package = "uPlot",
    elementId = elementId,
    sizingPolicy = htmlwidgets::sizingPolicy(
      defaultWidth = "100%",
      defaultHeight = "100%",
      viewer.defaultHeight = "100%",
      viewer.defaultWidth = "100%",
      knitr.figure = FALSE,
      knitr.defaultWidth = "100%",
      knitr.defaultHeight = "350px",
      browser.fill = TRUE,
      viewer.suppress = FALSE,
      browser.external = TRUE,
      padding = 5
    )
  )
}

#' Shiny bindings for uPlot
#'
#' Output and render functions for using uPlot within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a uPlot
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name uPlot-shiny
#'
#' @importFrom htmlwidgets shinyWidgetOutput shinyRenderWidget
#'
#' @export
uPlotOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'uPlot', width, height, package = 'uPlot')
}

#' @rdname uPlot-shiny
#' @export
renderUPlot <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, uPlotOutput, env, quoted = TRUE)
}
