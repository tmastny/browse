test_that("adding a path works", {

  actual_url <- "https://github.com/tmastny/browse/blob/b03704441535c5c5581da4be2c576c73f4d7d75e/R/browse.R#L46-L46"

  mock_url_object <- list(
    domain = "github",
    url = "https://github.com/tmastny/browse/blob/b03704441535c5c5581da4be2c576c73f4d7d75e/"
  )

  # TODO:
  #   I think this testing code is too low-level, and is indicating some
  #   weakness in the implementation. I should need to create the path objects
  #   to check if I can accurately append data. Or maybe I have to in the case of
  #   an Rstudio selection?
  #
  #   Or maybe there is a separate test for `test_path_manual` to split our
  #   into strt and end.
  #
  #   This indicates `#` might be illegal in file names which would help:
  #   https://www.mtu.edu/umc/services/digital/writing/characters-avoid/

  test_path_selection <- list(
    path = "R/browse.R",
    start = 46,
    end = 46
  )

  test_path_manual <- list(
    path = "R/browse.R#L46-L46",
    start = NULL,
    end = NULL
  )

  expect_equal(actual_url, add_path_to_url(mock_url_object, test_path_selection))
  expect_equal(actual_url, add_path_to_url(mock_url_object, test_path_manual))

  # TODO:
  #   fails because url is not a true in github.
  #   this is a breaking change from the current version,
  #   that doesn't demand the file exist in a github repo,
  #   but rather that the current working directory is in a repo.
  #
  #   Consider spliting on `#`?
  expect_equal(actual_url, link("R/browse.R#L46-L46"))
})
