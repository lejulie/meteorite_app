# Meteorite visuatlization - UI File

ui <- fluidPage(
  
  #titlePanel("Meteorite Data!"),
  
  navbarPage("Meteorite Landings",
    
    ##### Welcome Page #####
    tabPanel("Welcome!",
      # H1
      tags$div(class = "header", checked = NA,
       tags$h1("Let's Talk About Meteorites")),
      
      # What is a meteorite
      tags$div(class = "body", checked = NA,
       tags$h2('What is a meteorite?'),
       tags$p('According to ',
         tags$a(href=
'https://www.nasa.gov/audience/forstudents/k-4/dictionary/Meteorite.html',
          'NASA'),', a meteorite is “a rock 
          that has fallen to Earth from outer space.”  When a piece of debris 
          from an object (such as a comet or asteroid) enters the atmosphere of 
          a planet or moon (such as Earth), it becomes a ',tags$em('meteor'),
          ' as it descends towards the surface.  If the meteor survives passage 
          all the way to the planet or moon’s surface, it is then considered a ',
          tags$em('meteorite'),'.'
       ), # close paragraph
      tags$p('Meteors vary greatly in size, shape, and composition.  This app 
          lets you explores some of these attributes for over 30,000 meteorites 
          here on Earth.'), #close paragraph
      
      # What can you learn in this app?
      tags$h2('What can you learn in this app?'),
      tags$p('This app uses ',tags$a(href=
          'https://data.nasa.gov/Space-Science/Meteorite-Landings/gh4g-9sfh',
          'this data'),' aggregated by ',tags$a(href=
          'http://meteoriticalsociety.org/','The Meteoritical Society'),
          ' including information on the characteristics below:'),
        
        tags$h3('Meteorite sites'),
        tags$p('Check out a map of where meterorites where found across the globe.'),

        tags$h3('Fell vs. found'),
        tags$p('Meterorites can be classified on whether or not a person saw their 
               descent to Earth.  A meteorite that someone witnessed falling to Earth 
             and then successfully tracked down is classified as a ',tags$em('fall'),
               'or ',tags$em('fell'),'.  One that was determined to be a meteorite by 
               examination of its properties is classified as a ',tags$em('found'),' 
               meteorite.  See ',tags$a(href=
               'https://en.wikipedia.org/wiki/Meteorite_fall','Wikipedia'),' for 
               more.'),

        tags$h3('Meteorite categorization'),
        tags$p('Meteorites are also classified by their physical, chemical, isotopic, 
               and mineralogical properties, with the goal of grouping them ultimately 
               by their origin (rocks from the same source should be made of similar 
               stuff).  There are several taxonomies for classifying meterorites.  
               According to ',tags$a(href=
               'https://www.lpi.usra.edu/meteor/notes.php?note=6','the Meteoritical 
               Society'),'website,'),
        tags$blockquote('If the meteorite was published in both the Catalogue of 
                        Meteorites and MetBase (see columns NHMCat and MetBase), both 
                        classifications will appear if they do not agree. If the 
                        meteorite was just published in one of these sources, the 
                        classification from that source will be listed. If the 
                        meteorite was published in neither, the classification comes 
                        from the Meteoritical Bulletin (approved names) or from 
                        unreviewed reports (provisional names).'),
         tags$p('You can read more about the classification of meteorites on ',
         tags$a(href='https://en.wikipedia.org/wiki/Meteorite_classification',
                'Wikipedia.')),
         tags$h3('Meteorite mass'),
         tags$p('Meteorite masses in this dataset are in grams.  A note on masses 
              from ,',tags$a(href='https://www.lpi.usra.edu/meteor/notes.php?note=16',
                               'the Meteoritical Society'),' website.'),

         # Where does this data come from?
         tags$h2('Where does the data come from?'),
         tags$p('This data is provided by the ',tags$a(href='https://data.nasa.gov/',
                'NASA Open Data Portal.'),'  The source can be found  ',tags$a(href=
                'https://data.nasa.gov/Space-Science/Meteorite-Landings/gh4g-9sfh',
                'here.'),'  The data is originated from ',tags$a(href=
                'http://meteoriticalsociety.org/','The Meteoritical Society.')),
          tags$p('This app was built using the ',tags$a(href=
                'https://shiny.rstudio.com/','Shiny package'),' for R.'),

         # Who are you?
         tags$h2('Who are you?'),
         tags$p('My name is Julie Levine.  I’m a graduate from the School of 
                Engineering and Applied Science at the University of Pennsylvania.  
                In a past life I was a marketer and product manager for tech 
                startups ',tags$a(href='https://www.factual.com/','Fatual'),' and ',
         tags$a(href='https://www.datadoghq.com/','Datadog.'),'Presently, I’m a Data 
         Science Fellow at ', tags$a(href='https://nycdatascience.com/','NYC Data 
         Science Academy.'),'Check out more of my projects on the ',tags$a(href=
         'https://nycdatascience.com/blog/author/lejulie/','NYC Data Science Academy 
         blog.'))

      ) # close div
    ), # end welcome tab
    
    ##### Map ##### 
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
                               max = 13000, value = c(0, 13000))),
         
         column(3, sliderInput("year_range", label = h3("Year"), min = 300, 
                               max = 2013, value = c(300, 2013))),
         
         column(3, radioButtons("fall_found", label = h3("Fell or Found"),
                                choices = list("Fell or Found",
                                               "Fell Only",
                                               "Found Only"), 
                                selected = "Fell or Found")),
         
         column(3, selectInput("class", label = h3("Class"), 
                               choices = class_list_1, 
                               selected = 1))
       ), #close fluidrow
      
       #Add an extra row for a testing widget
       fluidRow(
         column(4, textOutput("test_values"))
       )
    ),
    
    #####  Histograms and scatterplots #####
    tabPanel("Break it Down",
       fluidRow(
         column(12,
                plotOutput("histogram")
         )
       ),
       
       br(),
       
       # Add a row for the widgets
       fluidRow(
         column(3, selectInput("hist_choice", label = h3("Choose Variable to Plot"), 
                               choices = list("Mass (g)", 
                                              "Year",
                                              "Fell/Found",
                                              "Class"), 
                               selected = "Mass (g)")
         )
       )
    ), # close break it down panel

    #####  Table of raw data #####
    tabPanel("Raw Data",
      DT::dataTableOutput("raw_table")
             )

  ) #close navbar layout
  
)