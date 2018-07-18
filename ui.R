# Meteorite visuatlization - UI File

ui <- fluidPage(
  
  #titlePanel("Meteorite Data!"),
  
  navbarPage("Meteorite Landings",
    
    # Nav options
    tabPanel("Welcome!"),
    tabPanel("Map Meteorites"),
    tabPanel("Break it Down"),
    tabPanel("Raw Data"),
    
    # Add a row for the map
    fluidRow(
      column(12,
        leafletOutput("mymap")
      )
    ),
    
    br(),
    
    # Add a row for the widgets
    fluidRow(
      column(3, wellPanel(
        sliderInput("mass_range", label = h3("Mass (g)"), min = 0, 
                           max = 13000, value = c(0, 13000)))),
      column(3, wellPanel(
        sliderInput("year_range", label = h3("Year"), min = 300, 
                           max = 2013, value = c(300, 2013)))),
      column(3, wellPanel(
        checkboxGroupInput("fall_found", label = h3("Fall or Found"), 
                           choices = list("Fall" = 1, "Found" = 2),
                           selected = c(1,2)))),
      column(3, wellPanel(
        selectInput("class", label = h3("Class"), 
                    choices = list("Choice 1" = 1, "Choice 2" = 2), 
                    selected = 1)))
      )
    # Fix widget heights
    
  ) #close navbar layout
  
)