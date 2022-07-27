
#  ------------------------------------------------------------------------
#
# eCO2mix data
# https://www.rte-france.com/eco2mix
#
#  ------------------------------------------------------------------------



# Packages ----------------------------------------------------------------

library(data.table)
library(fasttime)



# Download data -----------------------------------------------------------

dir.create("data-raw/input")
url <- "https://eco2mix.rte-france.com/download/eco2mix/eCO2mix_RTE_Annuel-Definitif_%s.zip"
annees <- 2012:2020
for (i in seq_along(annees)) {
  download.file(
    url = sprintf(url, annees[i]),
    destfile = file.path(
      "data-raw", "input", basename(sprintf(url, annees[i]))
    )
  )
  unzip(file.path(
    "data-raw", "input", basename(sprintf(url, annees[i]))
  ), exdir = "data-raw/input/")
}



# Read & transform data ---------------------------------------------------

eco2mix <- list.files(path = "eco2mix/", pattern = "\\.xls$", full.names = TRUE) |>
  lapply(data.table::fread, encoding = "Latin-1") |>
  data.table::rbindlist(fill = TRUE)

eco2mix <- eco2mix[, c(3, 4, 5, 8:16)]
setnames(eco2mix, c("date", "heure", "consumption", "fuel", "coal", "gas", "nuclear", "wind", "solar", "hydraulic", "pumping", "bioenergies"))

# fix 2013
fix2013 <- data.table::fread("eco2mix/eCO2mix_RTE_Annuel-Definitif_2013.xls", header = FALSE, encoding = "Latin-1")
fix2013 <- fix2013[, c(3, 4, 5, 8:16)]
setnames(fix2013, c("date", "heure", "consumption", "fuel", "coal", "gas", "nuclear", "wind", "solar", "hydraulic", "pumping", "bioenergies"))
eco2mix <- rbind(eco2mix, fix2013)

eco2mix[, date := fasttime::fastPOSIXct(paste(date, heure))]
eco2mix[, heure := NULL]
eco2mix <- eco2mix[!is.na(consumption)]
# eco2mix <- melt(data = eco2mix, id.vars = 1, variable.name = "source", value.name = "conso", na.rm = TRUE)


setorder(eco2mix, date)
setDF(eco2mix)



# Use data ----------------------------------------------------------------

usethis::use_data(eco2mix, internal = FALSE, overwrite = TRUE, compress = "xz")



# Colors mapping ----------------------------------------------------------

list(
  "bioenergies" = "#156956",
  "fuel" = "#80549f",
  "coal" = "#a68832",
  "solar" = "#d66b0d",
  "gas" = "#f20809",
  "wind" = "#72cbb7",
  "hydraulic" = "#2672b0",
  "nuclear" = "#e4a701",
  "pumping" = "#0e4269"
)

