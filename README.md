
<!-- README.md is generated from README.Rmd. Please edit that file -->

# browse

<!-- badges: start -->

<!-- badges: end -->

browse makes it easy to open Github links from RStudio. Try `Browse
remote files` addin while highlighting text in a file.

![](browse.gif)

## Installation

You can install the browse with:

``` r
devtools::install_github("tmastny/browse")
```

## Examples

You can also use

``` r
browse::browse()
```

in the console and outside of RStudio.

You can also use the relative file path:

``` r
browse("R/browse.R#L6-L9")
browse("R/browse.R#L6")
browse("R/browse.R")
```

Or just get the link to share with others:

``` r
browse::link("R/browse.R")
#> [1] "https://github.com/tmastny/browse/blob/428ed4c2dc6ba528e4bdcfcea7811b732a2a2319/R/browse.R"
#> attr(,"class")
#> [1] "browse_link" "character"
```
