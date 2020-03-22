function(input,output, session){
  
  ## carte leaflet
  output$map <- renderLeaflet({
    m <- leaflet(data = NULL) %>%
      addProviderTiles("Stamen.TonerLite")   %>%
      # markers UNV
      addMarkers(lng=coordinates(coordonnees)[,1],
                lat=coordinates(coordonnees)[,2],
                popup=infos_coord$nom_pharmacie,
                group = "pharmacie",
                layerId=infos_coord$id) 
    return(m)
  })
  
  observe({
    event <- input$map_marker_click
    if (is.null(event))
      return()
    print(event)
    pharmacie <- subset(infos_coord, id == event$id)
    ui <- shiny::div(id="selection",
      shiny::h3(pharmacie$nom_pharmacie),
      shiny::p(pharmacie$adresse_pharmacie,class="adresse"),
      shiny::p(paste0("du ",pharmacie$date_debut, " au ",pharmacie$date_fin),
               class="adresse"),
      shiny::p(pharmacie$message,class="message"),
      shiny::p(pharmacie$telephone,class="telephone"),
      shiny::p(pharmacie$mail)
    )
    shiny::removeUI("#selection")
    shiny::insertUI("#controls",where = "beforeEnd",
                    ui = ui)
  })
}
# pharmacie <- subset(infos_coord, id == 1)