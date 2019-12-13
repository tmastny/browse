# browse

<!-- badges: start -->
<!-- badges: end -->

browse makes it easy to open Github links from RStudio. 
Try the `Browse remote files` addin while highlighting text in a file.

![](browse.gif)

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

Or just get the link to share with others:

```r
link("R/browse.R")
```
