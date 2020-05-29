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
  #
  #   - this is a little tricky with the current implementation, since
  #     I simply check if the path object is a character string.
  #
  #     If I split the string on `#`, I would need both parts:
  #     the absolute url to check for the remote url.
  #
  #     Then the relative url (with L5 or L5-L5) to create the link.
  #     I would need to add some condition log on the split to see if
  #     i have a start (L5) or a start or end (L5-L5) if I wanted to parse it
  #     out. I could simply take it as is, but then I the object I have
  #     created would need to change.
  #
  #     I would need a new absolute path function that did the split a
  #     automatically.

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
