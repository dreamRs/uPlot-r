
#' Shiny bindings for uPlot
#'
#' Output and render functions for using uPlot within Shiny
#' applications and interactive Rmd documents.
#'
#' @inheritParams htmlwidgets::shinyWidgetOutput
#'
#' @name uPlot-shiny
#'
#' @importFrom htmlwidgets shinyWidgetOutput shinyRenderWidget
#'
#' @export
uPlotOutput <- function(outputId, width = "100%", height = "400px") {
  htmlwidgets::shinyWidgetOutput(outputId, "uPlot", width, height, package = "uPlot")
}

#' @inheritParams htmlwidgets::shinyRenderWidget
#' @rdname uPlot-shiny
#' @export
renderUPlot <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, uPlotOutput, env, quoted = TRUE)
}
