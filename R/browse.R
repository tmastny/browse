#' Link to Remote File
#'
#' Creates a Github permalink based on the repo in the current working directory.
#' Uses the current HEAD of the git repo.
#'
#' @param path The relative path of the file from the top of the git repo.
#' The default, \code{path = NULL} works on a RStudio selection.
#'
#' @examples
#' link("R/browse.R#L6-L9")
#' link("R/browse.R#L6")
#'
#' # works on RStudio selection
#' link()
#'
#' # opens URL in default browser
#' \dontrun{
#' link("R/install.R") %>%
#'   browseURL()
#' }
#'
#' @export
link <- function(path = NULL) {
  if (is.null(path)) {
    path <- selection_path()
  }

  github_url(path)
}

link_addin <- function() {
  rstudioapi::sendToConsole(link(), execute = FALSE)
}

github_url <- function(path) {
  repo_url <- git2r::remote_url() %>%
    stringr::str_sub(end = -5)

  head <- git2r::repository_head()

  commit <- git2r::lookup_commit(head) %>%
    as.data.frame()

  line_url <- paste0(repo_url, "/blob/", commit$sha, "/", path)

  class(line_url) <- c("browse_link", class(line_url))
  line_url
}

print.browse_link <- function(x, ...) {
  cat(x)
  invisible(x)
}

#' Opens Github File in Default Browser
#'
#' @description
#' Takes a relative file path (with option line numbers)
#' and opens the corresponding Github permalink in your default browser.
#'
#'
#' @examples
#' \dontrun{
#' browse("R/browse.R#L6-L9")
#' browse("R/browse.R#L6")
#'
#' browse("R/browse.R")
#' }
#'
#' @inheritParams link
#' @export
browse <- function(path = NULL) {
  link(path) %>%
    browseURL()
}

selection_path <- function() {
  doc <- rstudioapi::getSourceEditorContext()
  range <- rstudioapi::primary_selection(doc$selection)$range %>%
    rstudioapi::as.document_range()

  start <- range$start[[1]]
  end <- range$end[[1]]

  absolute_project_path <- paste0(here::here(), .Platform$file.sep)
  absolute_file_path <- path.expand(doc$path)

  relative_file_path <- stringr::str_remove(absolute_file_path, absolute_project_path)

  paste0(relative_file_path, "#L", start, "-L", end)
}
