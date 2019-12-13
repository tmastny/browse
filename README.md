
<!-- README.md is generated from README.Rmd. Please edit that file -->

# browse

<!-- badges: start -->

<!-- badges: end -->

browse makes it easy to open files in Github from RStudio. Try the
`Browse to remote file` addin while highlighting text in a file.

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

in the console.

Outside of RStudio, you can use the relative file path to open the file
on Github:

``` r
browse("R/browse.R#L6-L9")
browse("R/browse.R#L6")
browse("R/browse.R")
```

Or you can quickly get the link to share with others:

``` r
browse::link("R/browse.R")
#> [1] "https://github.com/tmastny/browse/blob/c064a6eedbee7af216f3472a97eeb8b2c3afeff6/R/browse.R"
#> attr(,"class")
#> [1] "browse_link" "character"
```
