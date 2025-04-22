
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

