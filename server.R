# Meteorite visuatlization - Server File

server <- function(input, output, session){

  ######################### FOR MAPS #########################
  
  # Reactive expression for mass range
  filtered.mass <- reactive({
    subset[subset$mass >= input$mass_range[1] &    # Change to scrubbed!!!
             subset$mass <= input$mass_range[2],]
  })
  
  # Color palette
  factpal <- colorFactor(c("red","blue"), subset$fall)
  
  output$mymap <- renderLeaflet({
    leaflet(data = subset) %>%                     # Change to scrubbed!!!
      addProviderTiles(providers$CartoDB.Positron) %>%
      addCircleMarkers(
        lng=subset$long,
        lat=subset$lat,
        radius = 2,
        color = ~factpal(fall),
        stroke = FALSE,
        fillOpacity = 0.5,
        clusterOptions = markerClusterOptions()) %>%
      addLegend("bottomright", pal = factpal, values = ~fall, title = "Fall Status",
                opacity = 1) %>%
      fitBounds(lng1 = -180, lat1 = -88, lng2 = 180, lat2 = 82)
  })
  
  # Incremental changes to the map should be performed in an observer. 
  # Each independent set of things that can change should be managed in
  # its own observer.
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
        fillOpacity = 0.5,
        clusterOptions = markerClusterOptions()) %>%
      addLegend("bottomright", pal = factpal, values = ~fall,  # add legend
                title = "Fall Status",
                opacity = 1)
  })
  
}