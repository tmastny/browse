test_that("https and ssh urls are parsed correctly", {
  https <- "https://gitlab.com/tmastny/browse2.git"
  ssh <- "git@gitlab.com:tmastny/browse2.git"

  https_parsed <- parse_remote_url(https)
  ssh_parsed <- parse_remote_url(ssh)

  expect_equal(https_parsed, ssh_parsed)
  expect_equal(ssh_parsed, list(domain = "gitlab", owner = "tmastny", name = "browse2"))
})
