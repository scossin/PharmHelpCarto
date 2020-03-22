####################### Pour leaflet : ##########################
library(shiny)
library(maptools)
library(leaflet)
library(jsonlite)
infos_coord <-jsonlite::fromJSON("./data/infos_coord22032020.json")
coordonnees <- infos_coord[,c(8,9)]

## set empty string if NA phone_number
bool <- is.na(infos_coord$telephone)
infos_coord$telephone[bool] <- ""
