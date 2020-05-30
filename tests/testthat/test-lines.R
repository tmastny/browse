test_that("correct link is returned when using a manual line numbers", {

  skip_if(not_git_repo)

  actual_url <- current_commit_url(lines = "#L46-L46")
  browse_link <- with_dir(here::here(), link("R/browse.R#L46-L46"))

  expect_equal(actual_url, browse_link)
})

test_that("line numbers are parsed correctly for domain", {

  github_line_numbers <- "#L46-L46"
  lines <- list(start = 46, end = 46)

  expect_equal(github_line_numbers, parse_lines(lines, domain = "github.com"))
})
