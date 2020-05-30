test_that("different file paths return the same link", {

  skip_if(not_git_repo)


  actual_url <- current_commit_url()

  link_at_top_level <- with_dir(here::here(), link("R/browse.R"))
  link_in_directory <- with_dir(here::here("R"), link("browse.R"))

  absolute_path_to_file <- here::here("R", "browse.R")

  link_outside_repo <- with_dir(tempdir(), link(absolute_path_to_file))

  expect_equal(actual_url, link_at_top_level)
  expect_equal(actual_url, link_in_directory)
  expect_equal(actual_url, link_outside_repo)
})

test_that("tilde file paths return the same link", {

  skip_if(not_git_repo)
  skip_if(no_tilde_dir)
  skip_if_not(file_exists)

  actual_url <- current_commit_url()

  link_with_tilde <- link("~/rpackages/browse/R/browse.R")

  expect_equal(actual_url, link_with_tilde)
})
