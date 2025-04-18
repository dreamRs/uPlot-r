library(uPlot)

# Hide x-axis
uPlot(eco2mix[1:150, c(1, 2, 6)]) %>%
  uAxesY(
    show = FALSE
  )

# x-axis on right
uPlot(eco2mix[1:150, c(1, 2, 6)]) %>%
  uAxesY(
    side = 1
  )


# label + style
uPlot(eco2mix[1:150, c(1, 2, 6)]) %>%
  uAxesY(
    label = "Y Axis",
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
