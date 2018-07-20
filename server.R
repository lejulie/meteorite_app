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
  
  ##### FOR BREAK IT DOWN #####
  
  hist_var = reactive({
    switch(input$hist_choice,
           # x, binwidth, stat, x axis
           "Mass (g)" = list(meteorites, meteorites$mass, 130, "count", "Mass (g)"),
           "Year" = list(meteorites, meteorites$year, 30, "count", "Year"),
           "Fell/Found" = list(meteorites, meteorites$fall, NULL, "count", 
                               "Fell/Found"),
           "Class" = list(meteorites[meteorites$class %in% class_list_top_50,], 
                          meteorites[meteorites$class %in% class_list_top_50,]$class,
                          NULL, "count", "Top 50 Classes")
           )
  })
  
  output$histogram = renderPlot(
    ggplot(data = hist_var()[[1]], aes(x = hist_var()[[2]])) +
      geom_bar(binwidth = hist_var()[[3]], stat = hist_var()[[4]]) + 
      xlab(hist_var()[[5]]) +
      ylab("Count") +
      theme(axis.text.x = element_text(angle = 90, hjust = 1))
  )
  
  ##### FOR DATA TABLE #####
  
  output$raw_table = DT::renderDataTable({ select(meteorites, -lat, -long)},colnames = 
        c('Name','ID', 'Name Type', 'Class','Mass', 'Fall or Found', 'Year',
          'Latitude', 'Longitude'), 
        options = list(pageLength = 15,
        columnDefs = list(list(className = 'dt-right', targets = 8:9),
                          list(className = 'dt-left', targets = 2))))
  
}