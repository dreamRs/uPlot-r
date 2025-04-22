#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
#' @param lhs A value or the magrittr placeholder.
#' @param rhs A function call using the magrittr semantics.
#' @return The result of calling `rhs(lhs)`.
NULL

#' Mark character strings as literal JavaScript code
#'
#' See [htmlwidgets::JS()] for details.
#'
#' @name JS
#' @keywords internal
#' @export
#' @importFrom htmlwidgets JS
#' @usage JS(...)
#' @inheritParams htmlwidgets::JS
#' @return A string that will be interpreted as JavaScript code in htmlwidgets.
htmlwidgets::JS
