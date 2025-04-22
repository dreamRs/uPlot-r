library(uPlot)

# Hide x-axis
uPlot(eco2mix[1:150, c(1, 2, 6)]) %>%
  uAxesX(
    show = FALSE
  )

# x-axis on top
uPlot(eco2mix[1:150, c(1, 2, 6)]) %>%
  uAxesX(
    side = 0
  )

# label + style
uPlot(eco2mix[1:150, c(1, 2, 6)]) %>%
  uAxesX(
    label = "X Axis",
    border = list( # axis line
      show = TRUE,
      stroke = "red"
    ),
    ticks = list( # axis ticks
      show = TRUE,
      stroke = "blue"
    ),
    stroke = "green" # label color
  )


# don't show grid lines
uPlot(eco2mix[1:150, c(1, 2, 6)]) %>%
  uAxesX(
    grid = list(show = FALSE)
  )
