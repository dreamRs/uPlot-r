
#' Cursor configuration
#'
#' @param uplot Chart created with [uPlot()].
#' @param ... Cursor options, see examples.
#'
#' @return An `htmlwidget` object of class `"uPlot"`.
#' @export
#'
#' @example examples/ex-uCursor.R
uCursor <- function(uplot, ...) {
  check_uplot(uplot)
  uplot$x$config$options$cursor <- list(...)
  return(uplot)
}
