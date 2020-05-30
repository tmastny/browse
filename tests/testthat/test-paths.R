test_that("correct link is returned from various working directories", {

  skip_if(not_git_repo)


  actual_browse_url <- current_commit_url()
  actual_description_url <- current_commit_url("DESCRIPTION")

  link_at_top_level <- with_dir(here::here(), link("R/browse.R"))
  link_in_directory <- with_dir(here::here("R"), link("browse.R"))
  link_to_file_above <- with_dir(here::here("R"), link("../DESCRIPTION"))

  absolute_path_to_file <- here::here("R", "browse.R")

  link_outside_repo <- with_dir(tempdir(), link(absolute_path_to_file))

  expect_equal(actual_browse_url, link_at_top_level)
  expect_equal(actual_browse_url, link_in_directory)
  expect_equal(actual_description_url, link_to_file_above)
  expect_equal(actual_browse_url, link_outside_repo)
})

test_that("correct link is returned when using a tilde", {

  skip_if(not_git_repo)
  skip_if(no_tilde_dir)
  skip_if_not(file_exists)

  actual_url <- current_commit_url()

  link_with_tilde <- link("~/rpackages/browse/R/browse.R")

  expect_equal(actual_url, link_with_tilde)
})
