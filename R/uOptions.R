
#' Options for uPlot
#'
#' @param uplot Chart created with [uPlot()].
#' @param ... Options for the chart.
#'
#' @return An `htmlwidget` object of class `"uPlot"`.
#' @export
#'
#' @examples
#' uPlot(eco2mix[1:24, c(1, 2)]) %>%
#'   uOptions(
#'     title = "Title for the chart"
#'   )
uOptions <- function(uplot, ...) {
  check_uplot(uplot)
  if (is.null(uplot$x$config$options))
    uplot$x$config$options <- list()
  uplot$x$config$options <- modifyList(
    x = uplot$x$config$options,
    val = drop_nulls(list(...))
  )
  return(uplot)
}



#' Series options
#'
#' @param uplot Chart created with [uPlot()].
#' @param serie Name (column's name in data) or index of the serie.
#' @param label Label to display in legend.
#' @param stroke Stroke color of the line.
#' @param ... Other options.
#'
#' @return An `htmlwidget` object of class `"uPlot"`.
#' @export
#'
#' @importFrom utils modifyList
#'
#' @example examples/ex-uSeries.R
uSeries <- function(uplot, serie, label = NULL, stroke = NULL, ...) {
  check_uplot(uplot)
  stopifnot(
    "'name' must be a character of length 1" = identical(length(serie), 1L)
  )
  if (is.character(serie)) {
    serie_index <- find_serie_index(uplot, serie)
  } else {
    serie_index <- as.numeric(serie)
  }
  uplot$x$config$options$series[[serie_index]] <- modifyList(
    x = uplot$x$config$options$series[[serie_index]],
    val = drop_nulls(list(
      label = label,
      stroke = stroke,
      ...
    ))
  )
  return(uplot)
}


find_serie_index <- function(uplot, name) {
  index <- which(uplot$x$series_nms == name)
  if (length(index) < 1)
    stop("uSeries: serie '", name, "' not found.")
  return(index)
}




#' Series colors
#'
#' Allow to specify series colors in one call.
#'
#' @param uplot Chart created with [uPlot()].
#' @param ... Colors to attribute to each series.
#'
#' @return An `htmlwidget` object of class `"uPlot"`.
#' @export
#'
#' @examples
#' uPlot(temperatures[, c("date", "temperature")]) %>%
#'   uColors(temperature = "black")
#'
#' uPlot(temperatures[, c("date", "low", "high")]) %>%
#'   uColors(
#'     low = "blue",
#'     high = "red"
#'   )
uColors <- function(uplot, ...) {
  args <- list(...)
  for (i in seq_along(args)) {
    uplot <- uSeries(uplot, serie = names(args)[i], stroke = args[[i]])
  }
  uplot
}




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

