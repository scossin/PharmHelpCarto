### Scrap the website
library(rvest)
library(dplyr)
text_rvest <- read_html("./Pharm'Help24032020.html") ## downloaded manually
cards <- text_rvest %>% html_nodes(".card")
length(cards) ## 81

## function to extract info from each card
getInfo <- function(card) {
  details <- card %>% html_nodes("p")
  nom_pharmacie <- details[1] %>% html_nodes(".is-size-4") %>% html_text()
  adresse_pharmacie <- details[1] %>% html_nodes("small") %>% html_text()
  fromto <- details[2] %>% html_nodes("strong")
  date_debut  <- fromto[1]  %>% html_text()
  date_fin  <- fromto[2]  %>% html_text()
  message <- details[4]  %>% html_text()
  if (length(details) == 6){
    telephone <- details[5]  %>% html_text()
    mail <- details[6]  %>% html_text()
  } else {
    telephone <- NA
    mail <- details[5]  %>% html_text()
  }
  
  # return
  return(data.frame(
    nom_pharmacie=nom_pharmacie,
    adresse_pharmacie=adresse_pharmacie,
    date_debut=date_debut,
    date_fin=date_fin,
    message=message,
    telephone=telephone,
    mail=mail
  ))
}
infos <- lapply(cards, getInfo)
infos <- do.call("rbind",infos) ## bind to dataframe
infos$nom_pharmacie <- trimws(infos$nom_pharmacie) # remove trailing spaces
infos$nom_pharmacie <- gsub("\\|$","",infos$nom_pharmacie) # remove separator
infos$nom_pharmacie <- trimws(infos$nom_pharmacie) # remove trailing again


############################# Geocodes addresses
library(httr)
library(jsonlite)
## API geocodage :
url <- "https://api-adresse.data.gouv.fr/search/"
adresse_pharmacie <- as.character(infos$adresse_pharmacie[1])
getCoordinates <- function(adresse_pharmacie){
  results <- httr::GET(url=url,query=list(q=adresse_pharmacie))
  results_json <- jsonlite::fromJSON(rawToChar(results$content))
  xy <- results_json$features$geometry$coordinates[[1]]
  return(data.frame(adresse_pharmacie=adresse_pharmacie,
                    x = xy[1],
                    y=xy[2]))
}

coordinates_xy <- lapply(infos$adresse_pharmacie, getCoordinates)
coordinates_xy2 <- do.call("rbind",coordinates_xy)
infos_coord <- merge(infos, coordinates_xy2, by="adresse_pharmacie")
infos_coord <- unique(infos_coord)
colnames(infos_coord)
infos_coord$id <- 1:nrow(infos_coord)

#### write Json 
library(jsonlite)
json_infos_coord <- jsonlite::toJSON(infos_coord)
writeLines(text = json_infos_coord, con="infos_coord24032020.json")
voir <- jsonlite::fromJSON("infos_coord24032020.json") ## check it opens correctly