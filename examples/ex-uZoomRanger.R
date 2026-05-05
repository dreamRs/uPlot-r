library(uPlot)

# Basic zoom ranger: select a window on the X axis,
# drag to pan, use grips to resize the selection.
uPlot(
  data = eco2mix[, c("datetime", "consumption")],
  options = list(
    title = "Electricity consumption in France",
    series = list(
      list(label = "Time"),
      list(label = "Consumption (MW)", stroke = "#0174DF")
    )
  )
) %>%
  uZoomRanger()
