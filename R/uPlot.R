#' @title uPlot
#'
#' @description Fast, memory-efficient Canvas 2D-based charts with Javascript library [µPlot](https://github.com/leeoniya/uPlot).
#'
#' @param data Data to plot as a `list` (must match `µPlot.js` expectations) or
#'  a `data.frame` where first column is the x-axis and the others the series to plot.
#' @param options Options to generate the plot.
#' @param ... Additional arguments.
#' @param use_gzipped_json Use [jsonlite::as_gzjson_b64()] to compress JSON data.
#' @param width,height A numeric input in pixels.
#' @param elementId Use an explicit element ID for the widget.
#'
#' @return An `htmlwidget` object of class `"uPlot"`.
#'
#' @importFrom htmlwidgets createWidget sizingPolicy
#' @importFrom grDevices palette
#' @importFrom jsonlite as_gzjson_b64
#'
#' @export
#'
#' @examples
#' uPlot::uPlot(
#'   data = list(
#'     as.numeric(eco2mix$date),
#'     eco2mix$consumption
#'   ),
#'   options = list(
#'     title = "Electricity consumption in France (2012 - 2020)",
#'     series = list(
#'       list(label = "Time"),
#'       list(label = "Consumption", stroke = "#088A08")
#'     )
#'   )
#' )
uPlot <- function(data,
                  options = list(),
                  ...,
                  use_gzipped_json = FALSE,
                  width = NULL,
                  height = NULL,
                  elementId = NULL) {

  options <- as.list(options)
  series_nms <- names(data)
  if (is.data.frame(data)) {
    data <- prepare_data(data)
    series_nms <- attr(data, ".nms")
  }
  if (is.null(options$series)) {
    strokes <- rep_len(palette(), length(series_nms))
    options$series <- prepare_options_series(
      label = series_nms,
      stroke = strokes
    )
  }
  if (is.null(options$bands)) {
    options$bands <- list()
  }

  x <- list(
    config = list(
      data = if (use_gzipped_json) as_gzjson_b64(data) else data,
      options = options,
      ...
    ),
    use_gzipped_json = use_gzipped_json,
    series_nms = series_nms
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
      # viewer.suppress = TRUE,
      # browser.external = TRUE,
      padding = 5
    )
  )
}

