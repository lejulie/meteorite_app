# Meteorite visuatlization - Server File

server <- function(input, output, session){

  ######################### FOR MAPS #########################
  
  # Reactive expression for mass range
  filtered.mass <- reactive({
    subset[subset$mass >= input$mass_range[1] &    # Change to scrubbed!!!
             subset$mass <= input$mass_range[2],]
    
  })
  
  # Reactive expression for fall widget
  # filtered.fall <- reactive({
  #   ifelse(input$fall_found == 1, subset,
  #          ifelse(input$fall_found == 2, subset[subset$fall=="Fell",],
  #                 subset[subset$fall=="Found",]))
  # })
  
  # Color palette
  factpal <- colorFactor(c("red","blue"), subset$fall)
  
  output$mymap <- renderLeaflet({
    leaflet(data = subset) %>%                     # Change to scrubbed!!!
      addProviderTiles(providers$CartoDB.Positron) %>%
      addCircleMarkers(
        lng=subset$long,
        lat=subset$lat,
        radius = 5,
        color = ~factpal(fall),
        stroke = FALSE,
        fillOpacity = 0.5,
        clusterOptions = markerClusterOptions(disableClusteringAtZoom = 8,
                                              spiderfyOnMaxZoom = FALSE)) %>%
      addLegend("bottomright", pal = factpal, values = ~fall, title = "Fall Status",
                opacity = 1) %>%
      fitBounds(lng1 = -180, lat1 = -88, lng2 = 180, lat2 = 82)
  })
  
  # Observer for mass range
  observe({
    mass = filtered.mass() # use the reactive function to get the dataset 
                           # scoped to the appropriate mass range
    
    leafletProxy("mymap", data = mass) %>%
      clearMarkers() %>%      # remove the existing markers
      clearControls() %>%     # remove the exisitng legend
      addCircleMarkers(       # add markers
        lng=mass$long,
        lat=mass$lat,
        radius = 5,
        color = ~factpal(fall),
        stroke = FALSE,
        fillOpacity = 0.5,
        clusterOptions = markerClusterOptions(disableClusteringAtZoom = 8,
                                              spiderfyOnMaxZoom = FALSE)) %>%
      addLegend("bottomright", pal = factpal, values = ~fall,  # add legend
                title = "Fall Status",
                opacity = 1)
  })
  
  # Observer for fall
  # observe({
  #   fall = filtered.fall()
  #   
  #   leafletProxy("mymap", data = fall) %>%
  #     clearMarkers() %>%      # remove the existing markers
  #     clearControls() %>%     # remove the exisitng legend
  #     addCircleMarkers(       # add markers
  #       lng=fall$long,
  #       lat=fall$lat,
  #       radius = 2,
  #       color = ~factpal(fall),
  #       stroke = FALSE,
  #       fillOpacity = 0.5,
  #       clusterOptions = markerClusterOptions()) %>%
  #     addLegend("bottomright", pal = factpal, values = ~fall,  # add legend
  #               title = "Fall Status",
  #               opacity = 1)
  # })
  
}