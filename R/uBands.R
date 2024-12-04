
#' Draw bands between series
#'
#' @param uplot Chart created with [uPlot()].
#' @param lower Name of the lower serie.
#' @param upper Name of the upper serie.
#' @param fill Fill color.
#' @param ... Other options.
#'
#' @return An `htmlwidget` object of class `"uPlot"`.
#' @export
#'
#' @example examples/ex-uBands.R
uBands <- function(uplot, lower, upper, fill, ...) {
  check_uplot(uplot)
  stopifnot(
    "'lower' must be a character of length 1" = is.character(lower) & identical(length(lower), 1L)
  )
  stopifnot(
    "'upper' must be a character of length 1" = is.character(upper) & identical(length(upper), 1L)
  )
  lower_index <- find_serie_index(uplot, lower)
  upper_index <- find_serie_index(uplot, upper)
  uplot$x$config$options$bands <- append(
    uplot$x$config$options$bands,
    list(drop_nulls(list(
      series = c(upper_index, lower_index) - 1,
      fill = fill,
      ...
    )))
  )
  return(uplot)
}

