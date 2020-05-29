library(withr)

not_git_repo <- inherits(try(git2r::workdir()), "try-error")

test_that("different file paths return the same link", {

  skip_if(not_git_repo)

  actual_url <- "https://github.com/tmastny/browse/blob/6f284f6b9f4ff7888c189739bacb6ec5f526392a/R/browse.R"

  link_at_top_level <- with_dir(here::here(), link("R/browse.R"))
  link_in_directory <- with_dir(here::here("R"), link("browse.R"))

  absolute_path_to_file <- here::here("R", "browse.R")

  link_outside_repo <- with_dir(tempdir(), link(absolute_path_to_file))

  expect_equal(actual_url, link_at_top_level)
  expect_equal(actual_url, link_in_directory)
  expect_equal(actual_url, link_outside_repo)
})

no_tilde_dir <- inherits(try(with_dir("~", getwd())), "try-error")

test_that("tilde file paths return the same link", {

  skip_if(not_git_repo)
  skip_if(no_tilde_dir)

  actual_url <- "https://github.com/tmastny/browse/blob/6f284f6b9f4ff7888c189739bacb6ec5f526392a/R/browse.R"

  link_with_tilde <- link("~/rpackages/browse/R/browse.R")

  expect_equal(actual_url, link_with_tilde)
})
