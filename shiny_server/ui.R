navbarPage(shiny::a("Pharm'Help",href="https://www.pharmhelp.anepf.org/"),
  
  # onglet carte         
  tabPanel("Mis à jour le 26/03/2020",
           # tout englobé dans div pour le CSS
           div(class="outer",
               tags$head(
                 # Include our custom CSS
                 includeCSS("style.css")
               ),
            # carte leaflet    
          leafletOutput("map", width="100%", height="100%"),
          
            # panel control pour la sélection
          absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                        draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                        width = 330, height = "auto",
                        div(id="selection"
                        )) # fermeture absolute panel
               ) # fermeture div
  ))


