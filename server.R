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
  
  ##### FOR DATA TABLE #####
  
  output$raw_table = DT::renderDataTable({ select(meteorites, -lat, -long)},colnames = 
        c('Name', 'ID', 'Class', 'Mass', 'Fall or Found', 'Year',
          'Latitude', 'Longitude'), 
        options = list(pageLength = 15,
        columnDefs = list(list(className = 'dt-right', targets = 7:8),
                          list(className = 'dt-left', targets = 2))))
 
  ##### FOR BETTER PLOTS #####
  m_mark <- list(color = toRGB("orange", 0.6))
  
  m_data = reactive({
    fell_found = switch(input$m_ff,
                        "Fell or Found" = c("Fell", "Found"),
                        "Fell Only" = "Fell",
                        "Found Only" = "Found")
    
    if(input$m_class == "Any"){
      opt = filter(meteorites, 
             fall %in% fell_found,
             year >= input$m_year[1],
             year <= input$m_year[2])
      opt$mass
    }
    else{
      opt = filter(meteorites, 
             fall %in% fell_found, 
             year >= input$m_year[1],
             year <= input$m_year[2],
             class == input$m_class)
      opt$mass
    }
  })
  
  output$m_plot <- renderPlotly({
    p = plot_ly(x = m_data(), type = "histogram", autobinx = T, 
                 xbins = list(start = 0, end = 13000, marker = m_mark))

    p %>%
      config(displayModeBar = F, showLink = F) %>%
      layout(showlegend = F, barmode = "overlay", yaxis = list(title = "Count"),
             xaxis = (list(title = "Mass (g)", showticklabels = T)))
  })
}




