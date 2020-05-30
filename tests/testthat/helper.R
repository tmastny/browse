library(withr)

current_commit_url <- function() {
  sha <- git2r::last_commit() %>% .$sha

  paste0(
    "https://github.com/tmastny/browse/blob/",
    sha, "/R/browse.R"
  )
}

not_git_repo <- inherits(try(git2r::workdir()), "try-error")
no_tilde_dir <- inherits(try(with_dir("~", getwd())), "try-error")
file_exists <- file.exists("~/rpackages/browse/R/browse.R")
