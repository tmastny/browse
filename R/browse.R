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
#' @export
link <- function(path = NULL, remote = "origin") {
  if (is.null(path)) {
    path <- selection_path()
  }

  remote_repo(remote) %>%
    craft_url(path)
}

craft_url <- function(repo, path) {
  UseMethod("craft_url")
}

craft_url.default <- function(repo, path) {
  stop(class(repo), " is not supported.")
}

craft_url.github <- function(repo, path) {
  paste0(
    "https://github.com/", repo$owner, "/", repo$name, "/blob/", repo$sha, "/",
    path$path, "#L", path$start, "-L", path$end
  )
}

craft_url.gitlab <- function(repo, path) {
  paste0(
    "https://gitlab.com/", repo$owner, "/", repo$name, "/blob/", repo$sha, "/",
    path$path, "#L", path$start
  )
}

craft_url.bitbucket <- function(repo, path) {
  paste0(
    "https://bitbucket.org/", repo$owner, "/", repo$name, "/src/", repo$sha, "/",
    path$path, "#lines-", path$start
  )
}

remote_repo <- function(remote) {
  if (!is.null(getOption("browse.remote.default"))) {
    remote <- getOption("browse.remote.default")
  }

  repo_url <- git2r::remote_url(remote = remote) %>%
    stringr::str_sub(end = -5)

  head <- git2r::repository_head()

  commit <- git2r::lookup_commit(head) %>%
    as.data.frame()

  owner <- repo_url %>%
    urltools::path() %>%
    stringr::str_split("/")

  repo_data <- list(owner = owner[[1]][1], name = owner[[1]][2], sha = commit$sha)

  class(repo_data) <- urltools::domain(repo_url) %>%
    urltools::suffix_extract() %>%
    .$domain

  repo_data
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
  link(path, remote = remote) %>%
    browseURL()
}
