library(withr)

test_that("different file paths return the same link", {

  skip_if(inherits(try(git2r::workdir()), "try-error"))

  link_at_top_level <- with_dir(here::here(), link("R/browse.R"))
  link_in_directory <- with_dir(here::here("R"), link("browse.R"))

  absolute_path_to_file <- here::here("R", "browse.R")

  link_outside_repo <- with_dir(tempdir(), link(absolute_path_to_file))

  expect_equal(link_at_top_level, link_in_directory)
  expect_equal(link_at_top_level, link_outside_repo)
  expect_equal(link_in_directory, link_outside_repo)
})

# TODO: paths with numbers
