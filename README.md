# browse

<!-- badges: start -->
<!-- badges: end -->

browse makes it easy to open Github links from RStudio.

## Installation

You can install the browse with:

``` r
devtools::install_github("tmastny/browse")
```

## Examples

You can also use 

```r
browse::browse()
```

in the console and outside of RStudio.

You can also use the relative file path:

```r
browse("R/browse.R#L6-L9")
browse("R/browse.R#L6")
browse("R/browse.R")
```
