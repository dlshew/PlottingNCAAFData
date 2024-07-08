#Getting Data with cfbfastR package
library(cfbfastR)
library(dplyr)

Sys.setenv(CFBD_API_KEY = "")

AdvStats23 <- cfbd_stats_season_advanced(2023)
