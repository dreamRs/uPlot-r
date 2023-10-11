
# Change label and color
uPlot(temperatures[, c("date", "temperature")]) %>%
  uSeries(
    name = "temperature",
    label = "Temperature in 2022",
    stroke = "steelblue"
  )

# Hide a serie at start
uPlot(temperatures) %>%
  uSeries(
    name = "temperature",
    show = FALSE
  )
