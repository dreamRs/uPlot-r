
uPlot::uPlot(
  data = list(
    NULL,
    list(
      rnorm(1e5),
      rnorm(1e5)
    )
  ),
  options = list(
    title = "Scatter",
    mode = 2,
    legend = list(live = FALSE),
    scales = list(
      x = list(time = FALSE),
      y = list()
    ),
    series = list(
      list(),
      list(stroke = "#DF0101", paths = htmlwidgets::JS("drawPoints"))
    )
  )
)

uPlot::uPlot(
  data = list(
    NULL,
    list(
      rnorm(1e5),
      rnorm(1e5)
    ),
    list(
      rnorm(1e5),
      rnorm(1e5)
    )
  ),
  options = list(
    title = "Scatter",
    mode = 2,
    legend = list(live = FALSE),
    scales = list(
      x = list(time = FALSE),
      y = list()
    ),
    series = list(
      list(),
      list(stroke = "#DF010180", paths = htmlwidgets::JS("drawPoints")) ,
      list(stroke = "#0431B480", paths = htmlwidgets::JS("drawPoints"))
    )
  )
)
