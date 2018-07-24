# Meteorite visuatlization - Server File

server = function(input, output, session){

  ##### WELCOME PAGE #####
  observeEvent(input$map_btn, { 
    updateNavbarPage(session, "inTabset", selected = "asdf")
    })
  
  observeEvent(input$plot_btn, { 
    updateTabsetPanel(session, "inTabset", selected = "Mass") 
  })
  
  ##### MAP #####
  
  # Reactive expression for widgets
  filtered.data = reactive({
    filter(meteorites,
      mass >= input$mass_range[1], 
      mass <= input$mass_range[2],
      year >= input$year_range[1],
      year <= input$year_range[2],
      fall %in% f_switch(input$fall_found),
      class %in% class_switch(input$class),
      country %in% country_switch(input$country))
  })
  
  sub.filtered.data = reactive({
    filter(meteorites, 
           #fall %in% f_switch(input$fall_found), 
           mass >= input$mass_range[1], 
           mass <= input$mass_range[2],
           year >= input$year_range[1],
           year <= input$year_range[2])
  })
  
  # Update map class list when changes are made
  observe({
    sub = filter(sub.filtered.data(), 
                 country %in% country_switch(input$country),
                 fall %in% f_switch(input$fall_found))
    
    class_list = c("Any",as.vector(unique(sub$class[order(sub$class)])))
      updateSelectInput(
        session, "class",
        choices = class_list,
        selected = input$class)
  })
  
  # Update map country list when changes are made
  observe({
    sub = filter(sub.filtered.data(), 
                 class %in% class_switch(input$class),
                 fall %in% f_switch(input$fall_found))
    
    country_list = c("Any",as.vector(unique(sub$country[order(sub$country)])))
    updateSelectInput(
      session, "country",
      choices = country_list,
      selected = input$country)
  })
  
  # Update fell/found list when changes are made
  observe({
    sub = filter(sub.filtered.data(),
           class %in% class_switch(input$class),
           country %in% country_switch(input$country))
    fall_list = c("Fell or Found",
                  paste(as.vector(unique(sub$fall[order(sub$fall)])),"Only")
                  )
    updateSelectInput(
      session, "fall_found",
      choices = fall_list,
      selected = input$fall_found)
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
          addLegend("bottomright", pal = factpal, values = ~fall, # add legend
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
  
  # Observe country change
  observeEvent(input$country, {
    redraw()
  })
 
  ##### PLOTS #####
  
  ##### Mass Plot #####
  
  m_data_fell = reactive({
    if(input$m_ff == "Found Only"){
      return(filter(meteorites, fall != "Fell", fall != "Found"))
    }
    if(input$m_class == "Any"){
      filter(meteorites, fall == "Fell", year >= input$m_year[1],
             year <= input$m_year[2]) %>%
      select(., mass, fall)}
    else{
      filter(meteorites, fall == "Fell", year >= input$m_year[1], 
             year <= input$m_year[2], class == input$m_class) %>%
      select(., mass, fall)}
  })
  
  m_data_found = reactive({
    if(input$m_ff == "Fell Only"){
      return(filter(meteorites, fall != "Fell", fall != "Found"))
    }
    if(input$m_class == "Any"){
      filter(meteorites, fall == "Found", year >= input$m_year[1],
             year <= input$m_year[2]) %>%
      select(., mass, fall)}
    else{
      filter(meteorites,fall == "Found", year >= input$m_year[1],
             year <= input$m_year[2], class == input$m_class) %>%
        select(., mass, fall)}
  })
  
  output$m_plot <- renderPlotly({
    p = plot_ly(alpha = 0.8, type = "histogram", autobinx = F,
                xbins = list(start = 0, end = 13000, size = 200)) %>%
      config(displayModeBar = F, showLink = F) %>%
      layout(showlegend = T, barmode = "overlay", 
             yaxis = list(title = "Count"),
             xaxis = (list(title = "Mass (g)", showticklabels = T)))
    
    if(nrow(m_data_found())>0){
      p = p %>% add_histogram(x = m_data_found()$mass, name = "Found",
                              marker = list(color = toRGB("#73A839", 0.6)))}
    if(nrow(m_data_fell())>0){
      p = p %>% add_histogram(x = m_data_fell()$mass, name = "Fell",
                              marker = list(color = toRGB("#2FA4E7", 0.8)))}
    p
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
  
  # Counts
  output$mass_counts = renderText({
    invisible(paste("Fell:", nrow(m_data_fell()),
                    "Found:", nrow(m_data_found()),
                    "Total:", nrow(m_data_found()) + nrow(m_data_fell()) ))
  })
  
  ##### Year Plot #####

  # y_data = reactive({
  #   if(input$y_class == "Any"){
  #     filter(meteorites, 
  #            fall %in% f_switch(input$y_ff),
  #            mass >= input$y_mass[1],
  #            mass <= input$y_mass[2]) %>%
  #       select(., year, fall)
  #   }
  #   else{
  #     filter(meteorites, 
  #            fall %in% f_switch(input$y_ff), 
  #            mass >= input$y_mass[1],
  #            mass <= input$y_mass[2],
  #            class == input$y_class) %>%
  #       select(., year, fall)
  #   }
  # })
  y_data_fell = reactive({
    if(input$y_ff == "Found Only"){
      return(filter(meteorites, fall != "Fell", fall != "Found"))
    }
    if(input$y_class == "Any"){
      filter(meteorites, fall == "Fell", 
             mass >= input$y_mass[1],
             mass <= input$y_mass[2]) %>%
        select(., year, fall)}
    else{
      filter(meteorites, fall == "Fell", 
             mass >= input$y_mass[1], 
             mass <= input$y_mass[2], 
             class == input$y_class) %>%
        select(., year, fall)}
  })
  
  y_data_found = reactive({
    if(input$y_ff == "Fell Only"){
      return(filter(meteorites, fall != "Fell", fall != "Found"))
    }
    if(input$y_class == "Any"){
      filter(meteorites, 
             fall == "Found", 
             mass >= input$y_mass[1],
             mass <= input$y_mass[2]) %>%
        select(., year, fall)}
    else{
      filter(meteorites,fall == "Found", 
             mass >= input$y_mass[1],
             mass <= input$y_mass[2], 
             class == input$y_class) %>%
        select(., year, fall)}
  })
  
  # output$y_plot <- renderPlotly({
  #   p = plot_ly(x = y_data()$year, type = "histogram", autobinx = T,
  #               xbins = list(start = 0, end = 13000), marker = list(
  #                 color = toRGB("#DD5600", 0.8)))
  #   p %>%
  #     config(displayModeBar = F, showLink = F) %>%
  #     layout(showlegend = F, barmode = "overlay", yaxis = list(title = "Count"),
  #            xaxis = (list(title = "Year", showticklabels = T)))
  # })
  
  output$y_plot <- renderPlotly({
    p = plot_ly(alpha = 0.8, type = "histogram", autobinx = F,
                xbins = list(start = 300, end = 2013, size = 1)) %>%
      config(displayModeBar = F, showLink = F) %>%
      layout(showlegend = T, barmode = "overlay", 
             yaxis = list(title = "Count"),
             xaxis = (list(title = "Year", showticklabels = T)))
    
    if(nrow(y_data_found())>0){
      p = p %>% add_histogram(x = y_data_found()$year, name = "Found",
                              marker = list(color = toRGB("#73A839", 0.6)))}
    if(nrow(y_data_fell())>0){
      p = p %>% add_histogram(x = y_data_fell()$year, name = "Fell",
                              marker = list(color = toRGB("#2FA4E7", 0.8)))}
    p
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
  
  # Counts
  output$year_counts = renderText({
    invisible(paste("Fell:", nrow(y_data_fell()),
                    "Found:", nrow(y_data_found()),
                    "Total:", nrow(y_data_fell())+nrow(y_data_found())))
  })
  
  ##### Class Plot #####
  
  output$c_table = DT::renderDataTable({ c_summary },colnames = 
        c("Class", "Average Mass (g)", "Count Fell","Count Found",
          "Total Count", "Percent of All Meteorites"), 
        options = list(pageLength = 15,
        columnDefs = list(list(className = 'dt-right', targets = c(2)))))
  
  ##### DATA TABLE #####
  
  output$raw_table = DT::renderDataTable({ select(meteorites, -lat, -long)},
         colnames = 
           c('Name', 'ID', 'Class', 'Mass', 'Fall or Found', 'Year',
             'Latitude', 'Longitude', 'Country'), 
         options = list(pageLength = 15,
                        columnDefs = list(list(className = 'dt-right', targets = 7:8),
                                          list(className = 'dt-left', targets = 2))))
  
}




