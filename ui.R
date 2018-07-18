# Meteorite visuatlization
# Meteorite landing data from
# https://data.nasa.gov/Space-Science/Meteorite-Landings/gh4g-9sfh

ui <- fluidPage(
  
  titlePanel("Meteorite Data!"),
  
  sidebarLayout(
    
    sidebarPanel(
      # Mass input slider
      sliderInput("mass_range", label = h3("Mass Range (g)"), min = 0, 
                  max = 13000, value = c(0, 1250))
    ),
    
    mainPanel(
      # Meteorite Map
      leafletOutput("mymap")
    )
  )
  
)