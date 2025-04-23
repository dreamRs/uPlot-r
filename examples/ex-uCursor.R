library(uPlot)

# disable crosshairs
uPlot(eco2mix[, c(1, 2)]) %>%
  uCursor(x = FALSE, y = FALSE)

# zoom on y only
uPlot(eco2mix[, c(1, 2)]) %>%
  uCursor(
    drag = list(y = TRUE, x = FALSE)
  )
