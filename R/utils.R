
all_numeric <- function(.data) {
  all(vapply(.data, FUN = is.numeric, FUN.VALUE = logical(1)))
}

prepare_data <- function(.data) {
  stopifnot(".data must be a data.frame or equivalent" = is.data.frame(.data))
  stopifnot(".data must have at least 2 columns" = ncol(.data) >= 2)
  stopifnot("First column of .data must be either a numeric or a POSIXct" = inherits(.data[[1]], c("numeric", "POSIXct", "Date")))
  stopifnot("All columns except first one of .data must numeric" = all_numeric(.data[, -1]))
  .nms <- names(.data)
  .data <- unname(as.list(.data))
  if (inherits(.data[[1]], c("Date"))) {
    .data[[1]] <- as.numeric(.data[[1]]) * 86400
  } else {
    .data[[1]] <- as.numeric(.data[[1]])
  }
  attr(.data, ".nms") <- .nms
  return(.data)
}

prepare_options_series <- function(...) {
  opts <- list(...)
  list(
    series = lapply(
      X = seq_along(opts[[1]]),
      FUN = function(i) {
        lapply(X = opts, FUN = `[[`, i)
      }
    )
  )
}
