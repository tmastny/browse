link_addin <- function() {
  rstudioapi::sendToConsole(link(), execute = FALSE)
}

#' Link to Remote File
#'
#' Creates a Github permalink based on the repo in the current working directory.
#' Uses the current HEAD of the git repo.
#'
#' @param path The relative path of the file from the top of the git repo.
#' The default, \code{path = NULL} works on a RStudio selection.
#'
#' @param remote Name of the remote to link to.
#' Optionally, you can change by setting
#' \code{options(browse.remote.default = "remote_name")}.
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
link <- function(path = NULL, remote = "origin") {
  if (is.null(path)) {
    path <- selection_path()
  }

  current_remote_sha_url(remote) %>%
    add_path_to_url(path)
}

add_path_to_url <- function(url, path) {
  UseMethod("add_path_to_url")
}

add_path_to_url.default <- function(url, path) {
  paste0(url, path$path, "#L", path$start, "-L", path$end)
}

add_path_to_url.gitlab <- function(url, path) {
  paste0(url, path$path, "#L", path$start)
}

current_remote_sha_url <- function(remote) {
  if (!is.null(getOption("browse.remote.default"))) {
    remote <- getOption("browse.remote.default")
  }

  repo_url <- git2r::remote_url(remote = remote) %>%
    stringr::str_sub(end = -5)

  head <- git2r::repository_head()

  commit <- git2r::lookup_commit(head) %>%
    as.data.frame()

  repo_sha_url <- paste0(repo_url, "/blob/", commit$sha, "/")

  class(repo_sha_url) <- urltools::domain(repo_sha_url) %>%
    urltools::suffix_extract() %>%
    .$domain

  repo_sha_url
}

selection_path <- function(url, path) {
  doc <- rstudioapi::getSourceEditorContext()
  range <- rstudioapi::primary_selection(doc$selection)$range %>%
    rstudioapi::as.document_range()

  start <- range$start[[1]]
  end <- range$end[[1]]

  absolute_project_path <- paste0(here::here(), .Platform$file.sep)
  absolute_file_path <- path.expand(doc$path)

  relative_file_path <- stringr::str_remove(absolute_file_path, absolute_project_path)

  list(path = relative_file_path, start = start, end = end)
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
browse <- function(path = NULL, remote = "origin") {
  link(path) %>%
    browseURL()
}
