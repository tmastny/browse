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
NULL

utils::globalVariables(".")

add_to_clipboard <- function(url) {

  # clipr implementation from reprex package:
  # https://github.com/tidyverse/reprex/blob/5ae0b298b2846bd5fdca610a6ef16b3032e2f1ac/R/reprex_impl.R#L89-L104

  if (clipboard_available()) {
    clipr::write_clip(url)
    message("Remote link is on the clipboard.")
  } else if (interactive()) {
    clipr::dr_clipr()
    message(
      "Unable to put link on the clipboard. Try to ",
      "capture what `link()` or `browse()` returns."
    )
  }
}

clipboard_available <- function() {
  if (interactive()) {
    clipr::clipr_available()
  } else {
    isTRUE(as.logical(Sys.getenv("CLIPR_ALLOW", FALSE)))
  }
}
