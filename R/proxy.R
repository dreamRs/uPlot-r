
#' Call a proxy method
#'
#' @param proxy  A \code{proxy} \code{htmlwidget} object.
#' @param name Proxy method.
#' @param ... Arguments passed to method.
#'
#' @return A \code{htmlwidgetProxy} \code{htmlwidget} object.
#' @noRd
.call_proxy <- function(proxy, name, ...) {
  if (!"htmlwidgetProxy" %in% class(proxy))
    stop("This function must be used with a htmlwidgetProxy object", call. = FALSE)
  proxy$session$sendCustomMessage(
    type = sprintf("uplot-%s", name),
    message = drop_nulls(list(id = proxy$id, ...))
  )
  proxy
}

#' Proxy for uPlot
#'
#' @param shinyId single-element character vector indicating the output ID of the
#'   chart to modify (if invoked from a Shiny module, the namespace will be added
#'   automatically).
#' @param session the Shiny session object to which the chart belongs; usually the
#'   default value will suffice.
#'
#' @return A `uProxy` object.
#'
#'
#' @export
#'
#' @importFrom shiny getDefaultReactiveDomain
#'
#' @examples
#' \dontrun{
#'
#' # Consider having created a editor widget with
#' uPlotOutput("mychart") # UI
#' output$mychart <- renderUPlot({}) # Server
#'
#' # Then you can call proxy methods in observer:
#'
#'
#' }
uProxy <- function(shinyId, session = shiny::getDefaultReactiveDomain()) {
  if (is.null(session)) {
    stop("uProxy must be called from the server function of a Shiny app")
  }
  if (!is.null(session$ns) && nzchar(session$ns(NULL)) && substring(shinyId, 1, nchar(session$ns(""))) != session$ns("")) {
    shinyId <- session$ns(shinyId)
  }
  structure(
    list(
      session = session,
      id = shinyId,
      x = list()
    ),
    class = c("uProxy", "htmlwidgetProxy")
  )
}


is_proxy <- function(uplot) {
  inherits(uplot, "uProxy")
}


#' Redraw a chart
#'
#' @param uplot Proxy for a chart created with [uProxy()].
#' @param rebuildPaths If `FALSE` use cached series.
#' @param recalcAxes Recalculate axes.
#'
#' @return An `htmlwidget` object of class `"uPlot"` or a `uProxy` object.
#' @export
#'
#'
#' @example examples/shiny-proxy-series-deladd.R
uRedraw <- function(uplot, rebuildPaths = TRUE, recalcAxes = TRUE) {
  if (is_proxy(uplot)) {
    proxy <- .call_proxy(
      proxy = uplot,
      name = "redraw",
      rebuildPaths = rebuildPaths,
      recalcAxes = recalcAxes
    )
    return(proxy)
  }
  check_uplot(uplot)
  warning("uRedraw: no method for uPlot object, can only be used with uProxy()")
  return(uplot)
}


#' Set data to a chart
#'
#' @param uplot Chart created with [uPlot()] or [uProxy()].
#' @param data The `data.frame` to use in chart.
#'
#' @return An `htmlwidget` object of class `"uPlot"` or a `uProxy` object.
#' @export
#'
#' @examples
#' uPlot() %>%
#'  uSetData(temperatures)
#'
#' @example examples/shiny-proxy-setdata.R
uSetData <- function(uplot, data) {
  if (is_proxy(uplot)) {
    proxy <- .call_proxy(
      proxy = uplot,
      name = "setData",
      data = prepare_data(data)
    )
    return(proxy)
  }
  check_uplot(uplot)
  data <- prepare_data(data)
  uplot$x$config$data <- data
  series_nms <- attr(data, ".nms")
  uplot$xseries_nms <- series_nms
  if (length(uplot$x$config$options$series) < 1) {
    strokes <- rep_len(palette(), length(series_nms))
    uplot$x$config$options$series <- prepare_options_series(
      label = series_nms,
      stroke = strokes
    )
  }
  return(uplot)
}


#' Update series to a chart via proxy
#'
#' @param uplot Chart created with [uPlot()] or [uProxy()].
#' @param seriesIdx Index of the serie to set.
#' @param show,focus Toggles series visibility or focus.
#' @param ... Options for the series, see [uSeries()].
#'
#' @return An `htmlwidget` object of class `"uPlot"` or a `uProxy` object.
#' @export
#'
#' @name proxy-series
#'
#' @examples
#' uPlot() %>%
#'  uSetData(temperatures)
#'
#' @example examples/shiny-proxy-series-visibility.R
#' @example examples/shiny-proxy-series-deladd.R
uSetSeries <- function(uplot, seriesIdx, show = TRUE, focus = NULL) {
  if (is_proxy(uplot)) {
    proxy <- .call_proxy(
      proxy = uplot,
      name = "setSeries",
      seriesIdx = seriesIdx - 1,
      options = drop_nulls(list(show = show, focus = focus))
    )
    return(proxy)
  }
  check_uplot(uplot)
  warning("uSetSeries: no method for uPlot object, can only be used with uProxy()")
  return(uplot)
}

#' @export
#'
#' @rdname proxy-series
uAddSeries <- function(uplot, seriesIdx, ...) {
  if (is_proxy(uplot)) {
    proxy <- .call_proxy(
      proxy = uplot,
      name = "addSeries",
      seriesIdx = seriesIdx - 1,
      options = list(...)
    )
    return(proxy)
  }
  check_uplot(uplot)
  uplot <- uSeries(uSeries, serie = seriesIdx, ...)
  return(uplot)
}

#' @export
#'
#' @rdname proxy-series
uDelSeries <- function(uplot, seriesIdx) {
  if (is_proxy(uplot)) {
    proxy <- .call_proxy(
      proxy = uplot,
      name = "delSeries",
      seriesIdx = seriesIdx - 1
    )
    return(proxy)
  }
  check_uplot(uplot)
  warning("uDelSeries: no method for uPlot object, can only be used with uProxy()")
  return(uplot)
}
