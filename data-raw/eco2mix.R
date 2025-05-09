
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

# Source: https://odre.opendatasoft.com/explore/dataset/eco2mix-national-cons-def/
# and https://odre.opendatasoft.com/explore/dataset/eco2mix-national-tr



# Read & transform data ---------------------------------------------------

eco2mix <- fread(file = "data-raw/input/eco2mix-national-cons-def.csv")
eco2mix <- eco2mix[, c(5, 6, 9:17)]
setnames(eco2mix, c("datetime", "consumption", "fuel", "coal", "gas", "nuclear", "wind", "solar", "hydraulic", "pumping", "bioenergies"))

# eco2mix_tr <- fread(file = "data-raw/input/eco2mix-national-tr.csv")
# eco2mix_tr <- eco2mix_tr[, c(5, 6, 9:17)]
# setnames(eco2mix_tr, c("datetime", "consumption", "fuel", "coal", "gas", "nuclear", "wind", "solar", "hydraulic", "pumping", "bioenergies"))

eco2mix <- rbind(eco2mix, eco2mix_tr)

eco2mix[, datetime := fasttime::fastPOSIXct(datetime)]
eco2mix <- eco2mix[!is.na(consumption)]
eco2mix <- eco2mix[minute(datetime) != 15]
eco2mix <- eco2mix[minute(datetime) != 45]
eco2mix <- eco2mix[minute(datetime) != 15]
eco2mix <- eco2mix[minute(datetime) == 0]
# eco2mix <- melt(data = eco2mix, id.vars = 1, variable.name = "source", value.name = "conso", na.rm = TRUE)


setorder(eco2mix, datetime)
setDF(eco2mix)



# Use data ----------------------------------------------------------------

usethis::use_data(eco2mix, internal = FALSE, overwrite = TRUE, compress = "bzip2")



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

