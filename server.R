# Meteorite visuatlization - Server File

server = function(input, output, session){

  ##### FOR MAPS #####
  
  # Reactive expression for widgets
  filtered.data = reactive({
    if(input$class == "Any"){
      filter(meteorites, 
             fall %in% f_switch(input$fall_found), 
             mass >= input$mass_range[1], 
             mass <= input$mass_range[2],
             year >= input$year_range[1],
             year <= input$year_range[2])}
    else{
      filter(meteorites, 
             fall %in% f_switch(input$fall_found), 
             mass >= input$mass_range[1], 
             mass <= input$mass_range[2],
             year >= input$year_range[1],
             year <= input$year_range[2],
             class == input$class)}
  })
  
  observe({
      sub = filter(meteorites, 
                   fall %in% f_switch(input$fall_found), 
                   mass >= input$mass_range[1], 
                   mass <= input$mass_range[2],
                   year >= input$year_range[1],
                   year <= input$year_range[2])
      class_list = c("Any", as.vector(unique(sub$class[order(sub$class)])))
      updateSelectInput(
        session, "class",
        choices = class_list,
        selected = class_list[1])
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
      setView(zoom = initial_zoom, 0, 0)
  })
  
  # Counts
  output$test_values = renderText({
    invisible(paste("Fell:", nrow(filtered.data()[filtered.data()$fall == 
                                                    "Fell",]),
                    "Found:", nrow(filtered.data()[filtered.data()$fall == 
                                                     "Found",]),
                    "Total:", nrow(filtered.data())))
  })
  
  redraw = function(){
    map = leafletProxy("mymap", data = filtered.data()) %>%
      clearControls() %>%            # remove the exisitng legend
      clearMarkerClusters() %>%      # remove the existing clusters
      addCircleMarkers(              # add markers
        lng=filtered.data()$long,
        lat=filtered.data()$lat,
        radius = circle_radius,
        color = ~factpal(fall),
        stroke = FALSE,
        fillOpacity = 0.5,
        clusterOptions = markerClusterOptions(disableClusteringAtZoom =
                                                max_cluster_zoom,
                                              spiderfyOnMaxZoom = FALSE))
    if(is.null(input$mymap_zoom) == FALSE){
      if(input$mymap_zoom < max_cluster_zoom){ #if zoom < cluster max, do nothing
        map
      }
      else{
        map %>%
          addLegend("bottomright", pal = factpal, values = ~fall, #otherwise add legend
                    title = "Fall Status",
                    opacity = 1)
      }
    }
  }
  
  # Observe mass change
  observeEvent(input$mass_range, {
    redraw()
  })
  
  # Observe year change
  observeEvent(input$year_range, {
    redraw()
  })
  
  # Observe fall change
  observeEvent(input$fall_found, {
    redraw()
  })
  
  # Observe class change
  observeEvent(input$class, {
    redraw()
  })
 
  ##### FOR PLOTS #####
  
  # Mass
  m_data = reactive({
    if(input$m_class == "Any"){
      filter(meteorites, 
             fall %in% f_switch(input$m_ff),
             year >= input$m_year[1],
             year <= input$m_year[2]) %>%
        select(., mass, fall)}
    else{
      filter(meteorites, 
             fall %in% f_switch(input$m_ff), 
             year >= input$m_year[1],
             year <= input$m_year[2],
             class == input$m_class) %>%
        select(., mass, fall)}
  })
  
  output$m_plot <- renderPlotly({
    p = plot_ly(x = m_data()$mass, type = "histogram", autobinx = T,
                xbins = list(start = 0, end = 13000, marker = list(
                  color = toRGB("orange", 0.6))))

    p %>%
      config(displayModeBar = F, showLink = F) %>%
      layout(showlegend = F, barmode = "overlay", yaxis = 
               list(title = "Count"),
             xaxis = (list(title = "Mass (g)", showticklabels = T)))
  })
  
  observe({
    sub = filter(meteorites, 
                 fall %in% f_switch(input$m_ff), 
                 year >= input$m_year[1],
                 year <= input$m_year[2])
    class_list = c("Any", as.vector(unique(sub$class[order(sub$class)])))
    updateSelectInput(
      session, "m_class",
      choices = class_list,
      selected = class_list[1])
  })
  
  # Year
  y_data = reactive({
    if(input$y_class == "Any"){
      filter(meteorites, 
             fall %in% f_switch(input$y_ff),
             mass >= input$y_mass[1],
             mass <= input$y_mass[2]) %>%
        select(., year, fall)
    }
    else{
      filter(meteorites, 
             fall %in% f_switch(input$y_ff), 
             mass >= input$y_mass[1],
             mass <= input$y_mass[2],
             class == input$y_class) %>%
        select(., year, fall)
    }
  })
  
  output$y_plot <- renderPlotly({
    p = plot_ly(x = y_data()$year, type = "histogram", autobinx = T,
                xbins = list(start = 0, end = 13000, marker = list(
                  color = toRGB("orange", 0.6))))
    
    p %>%
      config(displayModeBar = F, showLink = F) %>%
      layout(showlegend = F, barmode = "overlay", yaxis = list(title = "Count"),
             xaxis = (list(title = "Year", showticklabels = T)))
  })
  
  observe({
    sub = filter(meteorites, 
                 fall %in% f_switch(input$y_ff), 
                 mass >= input$y_mass[1],
                 mass <= input$y_mass[2])
    class_list = c("Any", as.vector(unique(sub$class[order(sub$class)])))
    updateSelectInput(
      session, "y_class",
      choices = class_list,
      selected = class_list[1])
  })
  
  # Class
  output$c_table = DT::renderDataTable({ c_summary },colnames = 
        c("Class", "Average Mass (g)", "Count Fell","Count Found",
          "Total Count", "Percent of All Meteorites"), 
        options = list(pageLength = 15,
        columnDefs = list(list(className = 'dt-right', targets = c(2)))))
  
  ##### FOR DATA TABLE #####
  
  output$raw_table = DT::renderDataTable({ select(meteorites, -lat, -long)},
         colnames = 
           c('Name', 'ID', 'Class', 'Mass', 'Fall or Found', 'Year',
             'Latitude', 'Longitude'), 
         options = list(pageLength = 15,
                        columnDefs = list(list(className = 'dt-right', targets = 7:8),
                                          list(className = 'dt-left', targets = 2))))
  
}




