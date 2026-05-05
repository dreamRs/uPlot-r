
#' Add a zoom ranger (range selector) below a uPlot chart
#'
#' Adds an interactive range-selector chart below the main uPlot chart.
#' The ranger allows the user to:
#' - drag the selection area to pan the main chart,
#' - drag the left/right grip handles to resize the selection,
#' - zoom the main chart by dragging directly on the ranger.
#' When the main chart's X scale changes (e.g. via cursor drag-zoom), the
#' ranger selection updates automatically.
#'
#' @param uplot Chart created with [uPlot()].
#' @param height Height of the ranger chart in pixels. Default is `80`.
#' @param stroke Stroke color for the series drawn in the ranger.
#'   Defaults to the stroke color(s) already set on the chart series.
#' @param grip_color Color of the left and right resize grip handles.
#'   Default is `"#4a90d9"`.
#' @param grip_width Width (in pixels) of the grip handles. Default is `8`.
#'
#' @return An `htmlwidget` object of class `"uPlot"`.
#' @export
#'
#' @example examples/ex-uZoomRanger.R
uZoomRanger <- function(uplot,
                        height = 80,
                        stroke = NULL,
                        grip_color = "#4a90d9",
                        grip_width = 8) {
  check_uplot(uplot)
  uplot$x$config$zoomRanger <- drop_nulls(list(
    height     = height,
    stroke     = stroke,
    gripColor  = grip_color,
    gripWidth  = grip_width
  ))
  return(uplot)
}
