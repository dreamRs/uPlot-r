
#  ------------------------------------------------------------------------
#
# temperature data for France
# https://data.enedis.fr/explore/dataset/donnees-de-temperature-et-de-pseudo-rayonnement
#
#  ------------------------------------------------------------------------



# Packages ----------------------------------------------------------------

library(data.table)
library(fasttime)




# Data --------------------------------------------------------------------

temperatures <- fread(file = "data-raw/input/donnees-de-temperature-et-de-pseudo-rayonnement.csv")
temperatures <- temperatures[, c(6, 7, 8, 2)]
setnames(temperatures, c("year", "month", "day", "temperature"))
temperatures <- temperatures[year > 2017]
temperatures <- temperatures[, list(temperature = round(mean(temperature, na.rm = TRUE), 1)), by = c("year", "month", "day")]
temperatures <- dcast(data = temperatures, formula = month + day ~ year, value.var = "temperature")
temperatures <- temperatures[!(month == 2 & day == 29)]

temperatures[, low := do.call(pmin, c(as.list(.SD), na.rm = TRUE)), .SDcols = as.character(2018:2021)]
temperatures[, high := do.call(pmax, c(as.list(.SD), na.rm = TRUE)), .SDcols = as.character(2018:2021)]
temperatures[, average := rowMeans(.SD, na.rm = TRUE), .SDcols = as.character(2018:2021)]
temperatures[, (as.character(2018:2021)) := NULL]
setnames(temperatures, "2022", "temperature")

temperatures[, date := as.Date("2022-01-01") + (seq_len(.N) - 1)]
temperatures[, (c("month", "day")) := NULL]
setcolorder(temperatures, "date")

temperatures




# Save --------------------------------------------------------------------

setDF(temperatures)
usethis::use_data(temperatures, internal = FALSE, overwrite = TRUE, compress = "xz")




# Example -----------------------------------------------------------------

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

