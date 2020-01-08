
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

in the RStudio console.

Outside of RStudio, you can use the relative file path to open the
remote file:

``` r
browse("R/browse.R#L6-L9")
browse("R/browse.R#L6")
browse("R/browse.R")
```
