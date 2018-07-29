# Meteorite visuatlization
# Meteorite landing data from
# https://data.nasa.gov/Space-Science/Meteorite-Landings/gh4g-9sfh
# Originally collected by http://www.meteoriticalsociety.org/ ?

library(shiny)
library(leaflet)
library(DT)
library(dplyr)
library(plotly)

# Read the data
meteorites = read.csv("./data/meteorites_with_countries.csv")
meteorites = select(meteorites, -X)
meteorites$lat_pretty = format(round(meteorites$lat, 3), nsmall=3)
meteorites$long_pretty = format(round(meteorites$long, 3), nsmall=3)

# Class summary
c_summary = read.csv("./data/class_summary_table.csv")
c_summary = select(c_summary, -X)

# Country summary
country_summary = read.csv("./data/country_summary_table.csv")
country_summary = select(country_summary, -X)

##### GLOBAL VARS #####

# Parameters for maps/charts
initial_zoom = 1
max_cluster_zoom = 4
circle_radius = 2
color_found = "#008148" # green
color_fell  = "#DD5600"  # orange

# Initial list of classes
class_list_1 = c("Any",
                 as.vector(unique(meteorites$class[order(meteorites$class)])))
class_list_top_50 = meteorites %>% 
  group_by(., class) %>% 
  summarise(., count = n()) %>%
  arrange(., desc(count))
class_list_top_50 = class_list_top_50$class[1:50]

# initial list of countries
country_list_1 = c("Any", 
                   as.vector(unique(meteorites$country[order(meteorites$country)])))

##### GLOBAL FUNCTIONS #####
f_switch = function(value){
  opt = switch(value,
         "Fell or Found" = c("Fell", "Found"),
         "Fell Only" = "Fell",
         "Found Only" = "Found")
  return(opt)
}
  
class_switch = function(value){
  ifelse(value == "Any",
         return(class_list_1),
         return(value))
}

country_switch = function(value){
  ifelse(value == "Any",
         return(country_list_1),
         return(value))
}
  