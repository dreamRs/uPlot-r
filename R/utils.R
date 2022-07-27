
all_numeric <- function(.data) {
  all(vapply(.data, FUN = is.numeric, FUN.VALUE = logical(1)))
}

prepare_data <- function(.data) {
  stopifnot(".data must be a data.frame or equivalent" = is.data.frame(.data))
  stopifnot(".data must have at leat 2 columns" = ncol(.data) >= 2)
  stopifnot("First column of .data must be either a numeric or a POSIXct" = inherits(.data[[1]], c("numeric", "POSIXct")))
  stopifnot("All columns except first one of .data must numeric" = all_numeric(.data[, -1]))
  .data <- unname(as.list(.data))
  .data[[1]] <- as.numeric(.data[[1]])
  return(.data)
}
