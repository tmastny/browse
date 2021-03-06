
<!-- README.md is generated from README.Rmd. Please edit that file -->

# browse

<!-- badges: start -->

<!-- badges: end -->

browse makes it easy to open files in Github from RStudio. Try the
`Browse to remote file` addin while highlighting text in a file.

![](browse.gif)

Alternatively, use `Link to remote file` to automatically copy the url
to your clipboard. This makes it easy to share links in Slack, Github,
and Twitter\!

## Installation

You can install browse with:

``` r
devtools::install_github("tmastny/browse")
```

`browse` now supports Bitbucket and Gitlab.

## Examples

You can also use

``` r
browse::browse()
browse::link()
```

in the RStudio console to browse to the file and line where your cursor
is in the editor.

And inside and outside RStudio, it also works as a command-line tool:

![](browse2.gif)

You can use a relative path from your working directory, or an absolute
path, as long as the file is in a git repo.

``` r
# working directory is the top level of repo
browse("R/browse.R")
browse("R/browse.R#L6-L9")

# working directory is the R/ folder of repo
browse("../README.md")

# relative or absolute paths to other repos
browse("~/rpackages/dplyr/DESCRIPTION")
```
