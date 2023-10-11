
# Ribbon between 2 series (always high > low)
uPlot(temperatures[, c("date", "low", "high")]) %>%
  uBands("low", "high", fill = "#4242424D")

# Ribbon between 2 intersecting series
uPlot(temperatures[, c("date", "temperature", "average")]) %>%
  uBands("temperature", "average", fill = "#F68180") %>%
  uBands("average", "temperature", fill = "#2F64FF")

