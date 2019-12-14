test_that("adding a path works", {
  actual_url <- "https://github.com/tmastny/browse/blob/b03704441535c5c5581da4be2c576c73f4d7d75e/R/browse.R#L46-L46"

  test_url <- list(
    domain = "github",
    url = "https://github.com/tmastny/browse/blob/b03704441535c5c5581da4be2c576c73f4d7d75e/"
  )
  test_path <- list(
    path = "R/browse.R",
    start = 46,
    end = 46
  )

  expect_equal(actual_url, add_path_to_url(test_url, test_path))
})
