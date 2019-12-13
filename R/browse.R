#' Format Github
#'
#' Formats Github URL based on the repo in the current working directory.
#'
#' @param path The relative path of the file from the top of the git repo.
#'
#' @examples
#' github_url("R/install.R#L29")
#'
#' github_url("R/install.R") %>%
#'   browseURL()
#'
#' @export
github_url <- function(path) {
  repo_url <- git2r::remote_url() %>%
    stringr::str_sub(end = -5)

  head <- git2r::repository_head()

  commit <- git2r::lookup_commit(head) %>%
    as.data.frame()

  line_url <- paste0(repo_url, "/blob/", commit$sha, "/", path)

  class(line_url) <- c("github_url", class(line_url))
  line_url
}

print.github_url <- function(x, ...) {
  cat(x)
  invisible(x)
}
