
#' X axis configuration
#'
#' @param uplot Chart created with [uPlot()].
#' @param ... Axis options.
#'
#' @return An `htmlwidget` object of class `"uPlot"`.
#' @export
#'
#' @example examples/ex-uAxesX.R
uAxesX <- function(uplot, ...) {
  check_uplot(uplot)
  uplot$x$config$options$axes[[1]] <- list(...)
  return(uplot)
}


#' Y axis configuration
#'
#' @param uplot Chart created with [uPlot()].
#' @param ... Axis options.
#'
#' @return An `htmlwidget` object of class `"uPlot"`.
#' @export
#'
#' @example examples/ex-uAxesY.R
uAxesY <- function(uplot, ...) {
  check_uplot(uplot)
  uplot$x$config$options$axes[[2]] <- list(...)
  return(uplot)
}
