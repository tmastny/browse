test_that("adding a path works", {

  actual_url <- "https://github.com/tmastny/browse/blob/b03704441535c5c5581da4be2c576c73f4d7d75e/R/browse.R#L46-L46"

  test_rstudio_selection <- list(
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
  expect_equal(actual_url, link("R/browse.R#L46-L46"))
})
