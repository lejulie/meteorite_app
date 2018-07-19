# Meteorite visuatlization - UI File

ui <- fluidPage(
  
  #titlePanel("Meteorite Data!"),
  
  navbarPage("Meteorite Landings",
    
    # Welcome Page
    tabPanel("Welcome!",
      tags$div(class = "header", checked = NA,
               tags$h1("Let's Talk About Meteorites"),
               tags$p("Placeholder copy here")
      )
    ),
    
    # Map
    tabPanel("Map Meteorites", 
       # Add a row for the map
       fluidRow(
         column(12,
                leafletOutput("mymap")
         )
       ),
       
       br(),
       
       # Add a row for the widgets
       fluidRow(
         column(3, sliderInput("mass_range", label = h3("Mass (g)"), min = 0, 
                               max = 13000, value = c(2500, 9000))),
         
         column(3, sliderInput("year_range", label = h3("Year"), min = 300, 
                               max = 2013, value = c(300, 2013))),
         
         column(3, radioButtons("fall_found", label = h3("Fell or Found"),
                                choices = list("Fell or Found",
                                               "Fell Only",
                                               "Found Only"), 
                                selected = "Fell or Found")),
         
         column(3, selectInput("class", label = h3("Class"), 
                               choices = list("Choice 1" = 1, "Choice 2" = 2), 
                               selected = 1))
       ) #close fluidrow
       
    ),
    
    # Histograms and scatterplots
    tabPanel("Break it Down"),

    # Table of raw data
    tabPanel("Raw Data")

  ) #close navbar layout
  
)