# Meteorite visuatlization - UI File

ui <- fluidPage(
  theme = "theme.css",

  navbarPage("Meteorite Landings",
    
    ##### Welcome Page #####
    tabPanel("Welcome!",
      # H1
      tags$div(class = "header", checked = NA,
               tags$h1("Investigating Meteorites")),
      fluidRow(
        column(12,
        tags$div(class = "body", checked = NA,
                 tags$p("Learn about meteorites using data from the ",
                 tags$a(href=
                 'https://data.nasa.gov/Space-Science/Meteorite-Landings/gh4g-9sfh',
                 'NASA Open Data Portal.'))),
        br())
      ),
      fluidRow(
        column(5, wellPanel(tags$h3("Map Meteorites"),
                  tags$p("See where meteories have landed around the world.")
                  #actionButton("map_btn", label = "Map")
                  )),
        column(5, wellPanel(tags$h3("Break It Down"),
                  tags$p("View breakdowns of meterorite characteristics.")
                  # actionButton("plot_btn", label = "Plot")
                  ))
      ),
      fluidRow(
        column(5, wellPanel(tags$h3("View Raw Data"),
                  tags$p("Check out a table of the raw data.")
                  # actionButton("raw_btn", label = "View")
                  )),
        column(5, wellPanel(tags$h3("Learn More"),
                  tags$p("Learn more about the info in this data set.")
                  # actionButton("learn_btn", label = "Learn")
                  ))
      )
    ), # end welcome tab
    
    ##### Map ##### 
    tabPanel("Map Meteorites",
       # H1
       tags$div(class = "header", checked = NA,
                tags$h1("Where Have Meteorites Been Found?")),
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
         
         column(2, selectInput("fall_found", label = h3("Fell or Found"),
                                choices = list("Fell or Found",
                                               "Fell Only",
                                               "Found Only"), 
                                selected = "Fell or Found")),
         
         column(2, selectInput("class", label = h3("Class"), 
                               choices = class_list_1, 
                               selected = 1)),
         column(2, selectInput("country", label = h3("Country"),
                               choices = country_list_1,
                               selected = 1))
       ), #close fluidrow
      
       #Add an extra row for a testing widget
       fluidRow(
         column(4, textOutput("test_values"))
       )
    ),
    
    #####  Histograms and scatterplots #####
    navbarMenu("Break it Down",
       # Mass
       tabPanel("Mass",
                # H1
                tags$div(class = "header", checked = NA,
                         tags$h1("Mass Histogram")),
              
                fluidRow(
                # Widgets
                column(4,
                       selectInput("m_class", label = h3("Class"), choices = 
                                     class_list_1, selected = 1),
                       sliderInput("m_year", label = h3("Year"), min = 300, 
                                      max = 2013, value = c(300, 2013)),
                       radioButtons("m_ff", label = h3("Fell or Found"),
                                       choices = list("Fell or Found", "Fell Only",
                                                      "Found Only"), 
                                       selected = "Fell or Found"),
                       textOutput("mass_counts")
                       ), #close column
                #Plot
                column(8, htmltools::div(style = "display:inline-block",
                                         plotlyOutput("m_plot", width = "auto", 
                                                      height = "auto"))))
                ), #close column

       # Year
       tabPanel("Year",
                # H1
                tags$div(class = "header", checked = NA,
                         tags$h1("Year Histogram")),
                fluidRow(
                column(4,
                       sliderInput("y_mass", label = h3("Mass (g)"), min = 0, 
                                  max = 13000, value = c(0, 13000)),
                       radioButtons("y_ff", label = h3("Fell or Found"),
                                    choices = list("Fell or Found",
                                                   "Fell Only",
                                                   "Found Only"), 
                                    selected = "Fell or Found"),
                       selectInput("y_class", label = h3("Class"), 
                                   choices = class_list_1, 
                                   selected = 1),
                       textOutput("year_counts")),
                column(8,htmltools::div(style = "display:inline-block", 
                               plotlyOutput("y_plot", width = "auto", height = 
                                              "auto"))))),
       
       # Class
       tabPanel("Class",
                # H1
                tags$div(class = "header", checked = NA,
                         tags$h1("Meteorite Classes")),
                # Table
                DT::dataTableOutput("c_table")
                )
       
                
       ), # close break it down panel

    #####  Table of raw data #####
    tabPanel("Raw Data", 
             tags$div(class = "header", checked = NA,
                      tags$h1("Raw Data")),
             DT::dataTableOutput("raw_table")),
     
    ##### Learn Page #####
    tabPanel("Learn",
      tags$div(class = "header", checked = NA,
               tags$h1("Let's Talk About Meteorites")),
      fluidRow(
        column(8,
      # What is a meteorite
      tags$div(class = "body", checked = NA,
       tags$h2('What is a meteorite?'),
       tags$p('According to ',
        tags$a(href=
        'https://www.nasa.gov/audience/forstudents/k-4/dictionary/Meteorite.html',
        'NASA'),', a meteorite is “a rock that has fallen to Earth from outer 
        space.”  When a piece of debris from an object (such as a comet or asteroid
        ) enters the atmosphere of a planet or moon (such as Earth), it becomes 
        a ',tags$em('meteor'),' as it descends towards the surface.  If the meteor 
        survives passage all the way to the planet or moon’s surface, it is then 
        considered a ',tags$em('meteorite'),'.'
       ), # close paragraph
       tags$p('Meteors vary greatly in size, shape, and composition.  This app 
        lets you explore some of these attributes for over 30,000 meteorites 
        here on Earth.'), #close paragraph
       
       # What can you learn in this app?
       tags$h2('What can you learn in this app?'),
       tags$p('This app uses ',tags$a(href=
        'https://data.nasa.gov/Space-Science/Meteorite-Landings/gh4g-9sfh',
        'this data'),' aggregated by ',tags$a(href=
        'http://meteoriticalsociety.org/','The Meteoritical Society,'),
        ' including information on the characteristics below:'),
       
       tags$h3('Meteorite sites'),
       tags$p('Check out a map of where meterorites where found across the globe.'),
       
       tags$h3('Fell vs. found'),
       tags$p('Meterorites can be classified on whether or not a person saw their 
        descent to Earth.  A meteorite that someone witnessed falling to Earth 
        and then successfully tracked down is classified as a ',tags$em('fall'),
        'or ',tags$em('fell'),'.  One that was determined to be a meteorite by 
        examination of its properties is classified as ',tags$em('found.'),' 
        See ',tags$a(href=
        'https://en.wikipedia.org/wiki/Meteorite_fall','Wikipedia'),' for 
        more.'),
       
       tags$h3('Meteorite categorization'),
       tags$p('Meteorites are also classified by their physical, chemical, isotopic, 
        and mineralogical properties, with the goal of grouping them ultimately 
        by their origin (rocks from the same source should be made of similar 
        stuff).  There are several taxonomies for classifying meterorites.  
        According to ',tags$a(href=
        'https://www.lpi.usra.edu/meteor/notes.php?note=6','the Meteoritical 
        Society'),'website, the data here adheres to the following:'),
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
        from',tags$a(href='https://www.lpi.usra.edu/meteor/notes.php?note=16',
        'the Meteoritical Society'),' website:',tags$blockquote('Masses are 
        taken from the Catalogue of Meteorites, MetBase, and/or the Meteoritical 
        Bulletin. In most cases, they represent the total known weight of the 
        meteorite. The masses shown here should not be considered as authoritative, 
        and may be rounded off.'))
      ) # close div
    ))
    ), #close Learn tab
    
    ##### About Page #####
    tabPanel("About",
       # H1
       tags$div(class = "header", checked = NA,
                tags$h1("About Me")),
       fluidRow(column(8,
       tags$div(class = "body", checked = NA,
         tags$p('My name is Julie Levine.  I’m a graduate from the School of 
          Engineering and Applied Science at the University of Pennsylvania.  
          In a past life, I was a marketer and product manager for tech 
          startups ',tags$a(href='https://www.factual.com/','Fatual'),' and ',
          tags$a(href='https://www.datadoghq.com/','Datadog.'),'Presently, I’m a Data 
          Science Fellow at ', tags$a(href='https://nycdatascience.com/','NYC Data 
          Science Academy.'),'Check out more of my projects on the ',tags$a(href=
          'https://nycdatascience.com/blog/author/lejulie/','NYC Data Science Academy 
          blog'),' and on ',tags$a(href=
          "https://github.com/lejulie?tab=repositories","github."))
        )))
      ) # close About tab

  ) # close navbar layout
  
)