# Meteorite visuatlization - Server File

server = function(input, output, session){

  ##### FOR MAPS #####
  
  # Reactive expression for widgets
  filtered.data = reactive({
    fell_found = switch(input$fall_found,
           "Fell or Found" = c("Fell", "Found"),
           "Fell Only" = "Fell",
           "Found Only" = "Found")
    
    if(input$class == "Any"){
      filter(meteorites, 
             fall %in% fell_found, 
             mass >= input$mass_range[1], 
             mass <= input$mass_range[2],
             year >= input$year_range[1],
             year <= input$year_range[2])
    }
    else{
      filter(meteorites, 
             fall %in% fell_found, 
             mass >= input$mass_range[1], 
             mass <= input$mass_range[2],
             year >= input$year_range[1],
             year <= input$year_range[2],
             class == input$class)
    }
  })
  
  class_list = reactive({
    unique(meteorites$class)
  })
  
  # Color palette
  factpal = colorFactor(c("red","blue"), c("Fell","Found"))
  
  # Map
  output$mymap = renderLeaflet({
    leaflet(data = meteorites) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addCircleMarkers(
        lng=meteorites$long,
        lat=meteorites$lat,
        radius = circle_radius,
        color = ~factpal(fall),
        stroke = FALSE,
        fillOpacity = 0.5,
        clusterOptions = markerClusterOptions(disableClusteringAtZoom = 
                                                max_cluster_zoom,
                                              spiderfyOnMaxZoom = FALSE)) %>%
      addLegend("bottomright", pal = factpal, values = ~fall, title = "Fall Status",
                opacity = 1) %>%
      setView(zoom = initial_zoom, 0, 0)
      #fitBounds(lng1 = -180, lat1 = -88, lng2 = 180, lat2 = 82)
  })
  
  # Test text box
  output$test_values = renderText({
    invisible(paste("Fell:", nrow(filtered.data()[filtered.data()$fall == "Fell",]),
                    "Found:", nrow(filtered.data()[filtered.data()$fall == "Found",]),
                    "Total:", nrow(filtered.data())))
  })
  
  # Observer for widget changes
  observe({
    leafletProxy("mymap", data = filtered.data()) %>%
      clearMarkerClusters() %>%      # remove the existing clusters
      clearControls() %>%            # remove the exisitng legend
      addCircleMarkers(              # add markers
        lng=filtered.data()$long,
        lat=filtered.data()$lat,
        radius = circle_radius,
        color = ~factpal(fall),
        stroke = FALSE,
        fillOpacity = 0.5,
        clusterOptions = markerClusterOptions(disableClusteringAtZoom = 
                                                max_cluster_zoom,
                                              spiderfyOnMaxZoom = FALSE)) %>%
      addLegend("bottomright", pal = factpal, values = ~fall,  # add legend
                title = "Fall Status",
                opacity = 1)
  })
  
  ##### FOR DATA TABLE #####
  
  output$raw_table = DT::renderDataTable({ meteorites })
  
}