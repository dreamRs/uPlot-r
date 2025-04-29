

#' Hooks for drawing lines and rectangles
#'
#' @param uplot Chart created with [uPlot()].
#' @param xintercept,yintercept,xmin,xmax,ymin,ymax Coordinates for lines and rectangles.
#' @param color,fill Color.
#' @param width Width for lines.
#' @param dash Line dash pattern.
#' @param alpha Transparency parameter.
#'
#' @return An `htmlwidget` object of class `"uPlot"`.
#' @export
#'
#' @name draw-lines-rectangles
#'
#' @example examples/ex-draw.R
uHookVLine <- function(uplot, xintercept, color = NULL, width = NULL, dash = NULL) {
  xintercept <- if (inherits(xintercept, "Date")) {
    as.numeric(xintercept) * 86400
  } else {
    as.numeric(xintercept)
  }
  check_uplot(uplot)
  params <- drop_nulls(list(
    xintercept = xintercept,
    color = color,
    width = width,
    dash = dash
  ))
  uplot$x$config$options$hooks$drawAxes <- c(
    uplot$x$config$options$hooks$drawAxes,
    list(
      JS(sprintf("drawVLine(%s)", jsonlite::toJSON(params)))
    )
  )
  return(uplot)
}

#' @export
#'
#' @rdname draw-lines-rectangles
uHookHLine <- function(uplot, yintercept, color = NULL, width = NULL, dash = NULL) {
  yintercept <- if (inherits(yintercept, "Date")) {
    as.numeric(yintercept) * 86400
  } else {
    as.numeric(yintercept)
  }
  check_uplot(uplot)
  params <- drop_nulls(list(
    yintercept = yintercept,
    color = color,
    width = width,
    dash = dash
  ))
  uplot$x$config$options$hooks$drawAxes <- c(
    uplot$x$config$options$hooks$drawAxes,
    list(
      JS(sprintf("drawHLine(%s)", jsonlite::toJSON(params)))
    )
  )
  return(uplot)
}

#' @export
#'
#' @rdname draw-lines-rectangles
uHookVRect <- function(uplot, xmin, xmax, fill = NULL, alpha = NULL) {
  xmin <- if (inherits(xmin, "Date")) {
    as.numeric(xmin) * 86400
  } else {
    as.numeric(xmin)
  }
  xmax <- if (inherits(xmax, "Date")) {
    as.numeric(xmax) * 86400
  } else {
    as.numeric(xmax)
  }
  check_uplot(uplot)
  params <- drop_nulls(list(
    xmin = xmin,
    xmax = xmax,
    fill = fill,
    alpha = alpha
  ))
  uplot$x$config$options$hooks$drawAxes <- c(
    uplot$x$config$options$hooks$drawAxes,
    list(
      JS(sprintf("drawVRect(%s)", jsonlite::toJSON(params)))
    )
  )
  return(uplot)
}


#' @export
#'
#' @rdname draw-lines-rectangles
uHookHRect <- function(uplot, ymin, ymax, fill = NULL, alpha = NULL) {
  ymin <- if (inherits(ymin, "Date")) {
    as.numeric(ymin) * 86400
  } else {
    as.numeric(ymin)
  }
  ymax <- if (inherits(ymax, "Date")) {
    as.numeric(ymax) * 86400
  } else {
    as.numeric(ymax)
  }
  check_uplot(uplot)
  params <- drop_nulls(list(
    ymin = ymin,
    ymax = ymax,
    fill = fill,
    alpha = alpha
  ))
  uplot$x$config$options$hooks$drawAxes <- c(
    uplot$x$config$options$hooks$drawAxes,
    list(
      JS(sprintf("drawHRect(%s)", jsonlite::toJSON(params)))
    )
  )
  return(uplot)
}

