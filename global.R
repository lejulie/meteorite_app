# Meteorite visuatlization
# Meteorite landing data from
# https://data.nasa.gov/Space-Science/Meteorite-Landings/gh4g-9sfh

library(shiny)
library(googleVis)
library(leaflet)
library(maps)

#setwd("~/Desktop/NYCDSA/projects/shiny_project/nasa_data/")
meteorites = read.csv("./data/meteorite_landings.csv")
names(meteorites)[names(meteorites) == 'reclat'] <- 'lat'
names(meteorites)[names(meteorites) == 'reclong'] <- 'long'
names(meteorites)[names(meteorites) == 'recclass'] <- 'class'
names(meteorites)[names(meteorites) == 'mass..g.'] <- 'mass'
meteorites$mass = as.numeric(meteorites$mass)
meteorites = select(meteorites, -GeoLocation)

# remove points missing lat/lng
scrubbed = meteorites[complete.cases(meteorites),]

# take a subset to test with
x = sample(1:nrow(scrubbed),5000,replace = FALSE) #random sample of 1000 rows
subset = scrubbed[x,]