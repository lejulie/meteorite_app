# Meteorite visuatlization
# Meteorite landing data from
# https://data.nasa.gov/Space-Science/Meteorite-Landings/gh4g-9sfh
# Originally collected by http://www.meteoriticalsociety.org/ ?

library(shiny)
library(leaflet)
library(DT)
library(dplyr)
library(googleVis)
library(plotly)

# Read the data
meteorites = read.csv("./data/cleaned_meteorites.csv")
meteorites = select(meteorites, -X, -nametype)
meteorites$lat_pretty = format(round(meteorites$lat, 3), nsmall=3)
meteorites$long_pretty = format(round(meteorites$long, 3), nsmall=3)

##### GLOBAL VARS #####

initial_zoom = 1
max_cluster_zoom = 4
circle_radius = 2
class_list_1 = c("Any", as.vector(unique(meteorites$class[order(meteorites$class)])))
class_list_top_50 = meteorites %>% 
  group_by(., class) %>% 
  summarise(., count = n()) %>%
  arrange(., desc(count))
class_list_top_50 = class_list_top_50$class[1:50]

c_avg_mass = meteorites %>% group_by(class) %>% summarise(avg_mass = mean(mass))
c_fell_found = meteorites %>% 
  group_by(class, fall) %>% 
  summarise(count = n()) %>%
  spread(key = fall, value = count)
c_summary = merge(c_avg_mass, c_fell_found)
c_summary[is.na(c_summary)] = 0
c_summary$avg_mass = round(c_summary$avg_mass,0)
c_total = sum(c_summary$Fell) + sum(c_summary$Found)
c_summary$total_row = c_summary$Fell + c_summary$Found
c_summary$pct_of_all = round(c_summary$total_row/c_total*100,3)
  
  
  