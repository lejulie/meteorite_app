# Meteorite visuatlization
# Meteorite landing data from
# https://data.nasa.gov/Space-Science/Meteorite-Landings/gh4g-9sfh

server <- function(input, output, session){

  # Reactive expression for mass range
  filtered.mass <- reactive({
    subset[subset$mass >= input$mass_range[1] & 
             subset$mass <= input$mass_range[2],]
  })
  
  # Color palette
  factpal <- colorFactor(c("red","blue"), subset$fall)
  
  output$mymap <- renderLeaflet({
    leaflet() %>% 
      addProviderTiles(providers$CartoDB.Positron)
  })
  
  # Incremental changes to the map should be performed in
  # an observer. Each independent set of things that can change
  # should be managed in its own observer.
  observe({
    mass = filtered.mass() # use the reactive function to get the dataset 
                           # scoped to the appropriate mass range
    
    leafletProxy("mymap", data = mass) %>%
      clearMarkers() %>%      # remove the existing markers
      clearControls() %>%     # remove the exisitng legend
      addCircleMarkers(       # add markers
        lng=mass$long,
        lat=mass$lat,
        radius = 2,
        color = ~factpal(fall),
        stroke = FALSE,
        fillOpacity = 0.5) %>%
      addLegend("bottomright", pal = factpal, values = ~fall,  # add legend
                title = "Fall Status",
                opacity = 1
      )
  })
  
}