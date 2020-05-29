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

  path_data <- file_location(path)

  url <- tools::file_path_as_absolute(path) %>%
    git2r::workdir() %>%
    remote_repo(remote) %>%
    remote_url() %>%
    add_path_to_url(path_data)

  add_to_clipboard(url)

  invisible(url)
}

file_location <- function(path) {
  start <- NULL
  end <- NULL

  if (is.null(path)) {
    doc <- rstudioapi::getSourceEditorContext()
    range <- rstudioapi::primary_selection(doc$selection)$range %>%
      rstudioapi::as.document_range()

    start <- range$start[[1]]
    end <- range$end[[1]]

    path <- doc$path
  }


  absolute_path <- path.expand(path) %>%
    tools::file_path_as_absolute()

  list(path = relative_path(absolute_path), start = start, end = end)
}

relative_path <- function(absolute_path, start, end) {
  absolute_project_path <- paste0(here::here(), .Platform$file.sep)

  stringr::str_remove(absolute_path, absolute_project_path)
}

add_path_to_url <- function(url, path) {
  if (is.null(path$start) & is.null(path$end)) {
    return(paste0(url$url, path$path))
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

remote_repo <- function(repo, remote) {
  if (!is.null(getOption("browse.remote.default"))) {
    remote <- getOption("browse.remote.default")
  }

  remote_data <- git2r::remote_url(repo, remote) %>%
    parse_remote_url()

  head <- git2r::repository_head(repo)

  commit <- git2r::lookup_commit(head) %>%
    as.data.frame()

  c(remote_data, list(sha = commit$sha))
}
