
# Change label and color
uPlot(temperatures[, c("date", "temperature")]) %>%
  uSeries(
    serie = "temperature",
    label = "Temperature in 2022",
    stroke = "steelblue"
  )

# Hide a serie at start
uPlot(temperatures) %>%
  uSeries(
    serie = "temperature",
    show = FALSE
  )

### Line style
# default
uPlot(temperatures[11:40, c("date", "temperature")]) %>%
  uSeries(
    serie = "temperature",
    paths = JS("uPlot.paths.linear()"),
    points = list(show = TRUE)
  )
# spline curve
uPlot(temperatures[11:40, c("date", "temperature")]) %>%
  uSeries(
    serie = "temperature",
    paths = JS("uPlot.paths.spline()"),
    points = list(show = TRUE)
  )
# stepped line
uPlot(temperatures[11:40, c("date", "temperature")]) %>%
  uSeries(
    serie = "temperature",
    paths = JS("uPlot.paths.stepped({align: 1})"),
    points = list(show = TRUE)
  )
