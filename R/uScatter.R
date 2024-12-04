
#' Create a scatter chart
#'
#' @param x Numeric vector to use on x-axis.
#' @param y Numeric vector to use on y-axis.
#' @param color A vector to identify different data series.
#' @param default_stroke Default stroke color to use if `color` is `NULL`.
#' @param label_x,label_y Labels for x and y axes.
#' @inheritParams uPlot
#'
#' @return An `htmlwidget` object of class `"uPlot"`.
#' @export
#'
#' @example examples/ex-uScatter.R
uScatter <- function(x,
                     y,
                     color = NULL,
                     default_stroke = "black",
                     label_x = NULL,
                     label_y = NULL,
                     options = list(),
                     use_gzipped_json = FALSE,
                     width = NULL,
                     height = NULL,
                     elementId = NULL) {
  data <- if (is.null(color)) {
    list(
      NULL,
      list(x, y)
    )
  }
  if (is.null(label_x))
    label_x <- deparse(substitute(x))
  if (is.null(label_y))
    label_y <- deparse(substitute(y))
  if (is.null(options$axes))
    options$axes <- list(list(), list())
  if (is.null(options$axes[[1]]$label))
    options$axes[[1]]$label <- label_x
  if (is.null(options$axes[[2]]$label))
    options$axes[[2]]$label <- label_y
  options$mode <- 2
  options$legend$show <- FALSE
  options$scales$x$time <- FALSE
  options$scales$y <- list()
  options$series[[2]]$paths <- htmlwidgets::JS("drawPoints")
  if (is.null(options$series[[2]]$stroke))
    options$series[[2]]$stroke <- default_stroke
  options$series[[1]] <- list()
  uPlot(
    data = data,
    options = options,
    use_gzipped_json = use_gzipped_json,
    width = width,
    height = height,
    elementId = elementId
  )
}
