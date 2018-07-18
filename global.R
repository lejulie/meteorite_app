# Meteorite visuatlization
# Meteorite landing data from
# https://data.nasa.gov/Space-Science/Meteorite-Landings/gh4g-9sfh
# Originally collected by http://www.meteoriticalsociety.org/ ?

library(shiny)
library(googleVis)
library(leaflet)
library(maps)
library(shinydashboard)

#setwd("~/Desktop/NYCDSA/projects/shiny_project/nasa_data/")
meteorites = read.csv("./data/meteorite_landings.csv")
names(meteorites)[names(meteorites) == 'reclat'] <- 'lat'
names(meteorites)[names(meteorites) == 'reclong'] <- 'long'
names(meteorites)[names(meteorites) == 'recclass'] <- 'class'
names(meteorites)[names(meteorites) == 'mass..g.'] <- 'mass'
meteorites$mass = as.numeric(meteorites$mass)
meteorites$year = as.numeric(substr(meteorites$year, 7,10))
meteorites = filter(meteorites, year < 2018)
meteorites = select(meteorites, -GeoLocation)

# remove points missing lat/lng
scrubbed = meteorites[complete.cases(meteorites),]

# take a subset to test with
x = sample(1:nrow(scrubbed),5000,replace = FALSE) #random sample of 1000 rows
subset = scrubbed[x,]


# Meteorites with funy years
# Ur-  https://www.lpi.usra.edu/meteor/metbull.php?sea=Ur&sfor=names&ants=&nwas=&falls=&valids=&stype=exact&lrec=50&map=ge&browse=&country=All&srt=name&categ=All&mblist=All&rect=&phot=&snew=0&pnt=Normal%20table&code=24125)
# Northwest Africa 7701 - https://www.lpi.usra.edu/meteor/metbull.php?sea=Northwest+Africa+7701&sfor=names&ants=&nwas=&falls=&valids=&stype=contains&lrec=50&map=ge&browse=&country=All&srt=name&categ=All&mblist=All&rect=&phot=&snew=0&pnt=Normal%20table&code=57150
