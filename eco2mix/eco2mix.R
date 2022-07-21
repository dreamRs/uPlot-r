
#  ------------------------------------------------------------------------
#
# Title : eCO2mix data
#    By :
#  Date : 2022-07-21
#
#  ------------------------------------------------------------------------



# Packages ----------------------------------------------------------------

library(data.table)
library(fasttime)



# Download data -----------------------------------------------------------

url <- "https://eco2mix.rte-france.com/download/eco2mix/eCO2mix_RTE_Annuel-Definitif_%s.zip"
annees <- 2012:2020
for (i in seq_along(annees)) {
  download.file(
    url = sprintf(url, annees[i]),
    destfile = file.path(
      "eco2mix", basename(sprintf(url, annees[i]))
    )
  )
  unzip(file.path(
    "eco2mix", basename(sprintf(url, annees[i]))
  ), exdir = "eco2mix/")
}



# Read & prepare data -----------------------------------------------------

eco2mix <- list.files(path = "eco2mix/", pattern = "\\.xls$", full.names = TRUE) |>
  lapply(data.table::fread, encoding = "Latin-1") |>
  data.table::rbindlist(fill = TRUE)

eco2mix <- eco2mix[, c(3, 4, 5)]
setnames(eco2mix, c("date", "heure", "conso"))

# fix 2013
fix2013 <- data.table::fread("eco2mix/eCO2mix_RTE_Annuel-Definitif_2013.xls", header = FALSE, encoding = "Latin-1")
fix2013 <- fix2013[, c(3, 4, 5)]
setnames(fix2013, c("date", "heure", "conso"))
eco2mix <- rbind(eco2mix, fix2013)

eco2mix <- eco2mix[!is.na(conso)]
eco2mix[, date := fasttime::fastPOSIXct(paste(date, heure))]
eco2mix[, heure := NULL]

setorder(eco2mix, date)


uPlot::uPlot(
  data = list(
    as.numeric(eco2mix$date),
    eco2mix$conso
  ),
  options = list(
    title = "France consommation (2012 - 2020)",
    series = list(
      list(label = "Time"),
      list(label = "Conso", stroke = "red")
    )
  )
)







