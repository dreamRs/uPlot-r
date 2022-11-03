
# uPlot

> R htmlwidget for [µPlot](https://github.com/leeoniya/uPlot) JavaScript library. μPlot is a fast, memory-efficient Canvas 2D-based chart for plotting time series, lines, areas, ohlc & bars.

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/dreamRs/uPlot-r/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/dreamRs/uPlot-r/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->


:warning: Doesn't work in RStudio viewer. :warning:


## Installation

You can install the development version of uPlot from [GitHub](https://github.com/dreamRs/uPlot-r) with:

```r
# install.packages("remotes")
remotes::install_github("dreamRs/uPlot-r")
```

## Example

Here's a time series in half-hourly steps over 11 years, representing a total of 1,710,612 points (9 series of 190,068).

```r
library(uPlot)
uPlot(
  data = eco2mix[, c(1, 3:11)],
  options = list(
    title = "Electricity production by sources in France (2012 - 2022)",
    series = list(
      list(label = "Time"),
      list(label = "fuel", stroke = "#80549f"),
      list(label = "coal", stroke = "#a68832"),
      list(label = "gas", stroke = "#f20809"),
      list(label = "nuclear", stroke = "#e4a701"),
      list(label = "wind", stroke = "#72cbb7"),
      list(label = "solar", stroke = "#d66b0d"),
      list(label = "hydraulic", stroke = "#2672b0"),
      list(label = "pumping", stroke = "#0e4269"),
      list(label = "bioenergies", stroke = "#156956")
    )
  )
)
```
![uPlot example](man/figures/uplot.png)



Area ranges examples :

```r
uPlot(
  data = temperatures,
  options = list(
    title = "Temperatures in 2022 with range from 2018 to 2021",
    series = list(
      list(label = "Date"),
      list(label = "Temperature (°C)", stroke = "red", width = 2),
      list(label = "Low", stroke = "#848585", dash = c(8, 2)),
      list(label = "High", stroke = "#848585", dash = c(8, 2))
    ),
    bands = list(
      list(series = c(2, 3), fill = "#8485854D", dir = 1)
    ),
    axes = list(
      list(),
      list(
        label = "Temperature in degree celsius",
        values = htmlwidgets::JS("function(u, vals) {return vals.map(v => v + '°C');}")
      )
    )
  )
)
```

![temperature 1 example](man/figures/temperature1.png)


```r
uPlot(
  data = temperatures[, c(1, 2, 5)],
  options = list(
    title = "Temperatures in 2022 compared to average from previous years",
    series = list(
      list(label = "Date"),
      list(
        label = "Temperature 2022", stroke = "red", width = 2,
        value = htmlwidgets::JS("function(u, v) {return v + '°C';}")
      ),
      list(
        label = "Average 2018-2021", stroke = "black", width = 2,
        value = htmlwidgets::JS("function(u, v) {return v + '°C';}")
      )
    ),
    bands = list(
      list(series = c(1, 2), fill = "#F681804D"),
      list(series = c(2, 1), fill = "#2F64FF4D")
    ),
    axes = list(
      list(),
      list(
        label = "Temperature in degree celsius",
        values = htmlwidgets::JS("function(u, vals) {return vals.map(v => v + '°C');}")
      )
    )
  )
)
```

![temperature 2 example](man/figures/temperature2.png)

