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
#'
#' # works on an RStudio selection
#' browse()
#'
#' }
#'
#' @inheritParams link
#' @export
browse <- function(path = NULL, remote = "origin") {
  url <- link(path, remote = remote) %>%
    utils::browseURL()

  invisible(url)
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
#' \dontrun{
#' link("R/browse.R#L6-L9")
#' link("R/browse.R#L6")
#'
#' # works on a RStudio selection
#' link()
#' }
#'
#' @export
link <- function(path = NULL, remote = "origin") {
  if (is.null(path)) {
    path <- selection_path()
  }

  url <- remote_repo(remote) %>%
    remote_url() %>%
    add_path_to_url(path)

  add_to_clipboard(url)

  invisible(url)
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

  list(path = relative_file_path, start = start, end = end)
}

add_path_to_url <- function(url, path) {
  if (is.character(path)) {
    return(paste0(url$url, path))
  }

  switch(
    url$domain,
    github = paste0(url$url, path$path, "#L", path$start, "-L", path$end),
    gitlab = paste0(url$url, path$path, "#L", path$start),
    bitbucket = paste0(url$url, path$path, "#lines-", path$start)
  )
}

remote_url <- function(repo) {
  web_ext <- list(
    github = ".com",
    gitlab = ".com",
    bitbucket = ".org"
  )

  web_src <- list(
    github = "blob",
    gitlab = "blob",
    bitbucket = "src"
  )

  stopifnot(repo$domain %in% names(web_ext))

  list(
    domain = repo$domain,
    url = paste0(
      "https://", repo$domain, web_ext[[repo$domain]],  "/",
      repo$owner, "/", repo$name, "/", web_src[[repo$domain]], "/", repo$sha, "/"
    )
  )
}

strip_git_ext <- function(url) {
  stringr::str_sub(url, end = -5)
}

parse_ssh_url <- function(url) {
  components <- url %>%
    stringr::str_split(":")

  shh_components <- components[[1]][1] %>%
    stringr::str_split("@")

  domain <- shh_components[[1]][2] %>%
    urltools::suffix_extract() %>%
    .$domain

  repo <- components[[1]][2] %>%
    stringr::str_split("/")

  list(
    domain = domain,
    owner = repo[[1]][1],
    name = repo[[1]][2]
  )
}

parse_remote_url <- function(url) {
  url <- strip_git_ext(url)
  if (stringr::str_detect(url, "@")) {
    return(parse_ssh_url(url))
  }

  url_components <- urltools::url_parse(url)

  domain <- url_components$domain %>%
    urltools::suffix_extract() %>%
    .$domain

  repo <- url_components$path %>%
    stringr::str_split("/")

  list(
    domain = domain,
    owner = repo[[1]][1],
    name = repo[[1]][2]
  )
}

remote_repo <- function(remote) {
  if (!is.null(getOption("browse.remote.default"))) {
    remote <- getOption("browse.remote.default")
  }

  remote_data <- git2r::remote_url(remote = remote) %>%
    parse_remote_url()

  head <- git2r::repository_head()

  commit <- git2r::lookup_commit(head) %>%
    as.data.frame()

  c(remote_data, list(sha = commit$sha))
}
