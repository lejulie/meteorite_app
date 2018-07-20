# Meteorite visuatlization
# Meteorite landing data from
# https://data.nasa.gov/Space-Science/Meteorite-Landings/gh4g-9sfh
# Originally collected by http://www.meteoriticalsociety.org/ ?

library(shiny)
library(leaflet)
library(DT)
library(dplyr)

# Read the data
meteorites = read.csv("./data/cleaned_meteorites.csv")
meteorites = select(meteorites, -X)
meteorites$lat_pretty = format(round(meteorites$lat, 3), nsmall=3)
meteorites$long_pretty = format(round(meteorites$long, 3), nsmall=3)

#backup = meteorites
#meteorites = backup

#####   DATA CLEANING - TO DO EXTERNALLY #####

# # Update some column names
# names(meteorites)[names(meteorites) == 'reclat'] <- 'lat'
# names(meteorites)[names(meteorites) == 'reclong'] <- 'long'
# names(meteorites)[names(meteorites) == 'recclass'] <- 'class'
# names(meteorites)[names(meteorites) == 'mass..g.'] <- 'mass'
# 
# # Convert mass and year to numerics
# meteorites$mass = as.numeric(meteorites$mass)
# meteorites$year = as.numeric(substr(meteorites$year, 7,10))
# 
# # Remove any nonsense points and unnecessary columns
# meteorites = filter(meteorites, year < 2018)
# meteorites = filter(meteorites, long > -180 & long < 180)
# meteorites = filter(meteorites, lat > -90 & lat < 90)
# meteorites = mutate(meteorites, keep = ifelse(lat ==0 & long ==0, "drop", "keep"))
# meteorites = filter(meteorites, keep == "keep")
# meteorites = select(meteorites, -GeoLocation, -keep)
# 
# # remove points missing lat/lng
# meteorites = meteorites[complete.cases(meteorites),]

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

##### NOTES #####

# take a subset to test with
# x = sample(1:nrow(meteorites),20000,replace = FALSE) #random sample of 10,000 rows
# subset = meteorites[x,]


# Meteorites with funny years
# Ur-  https://www.lpi.usra.edu/meteor/metbull.php?sea=Ur&sfor=names&ants=&
#nwas=&falls=&valids=&stype=exact&lrec=50&map=ge&browse=&country=All&srt=name&c
#ateg=All&mblist=All&rect=&phot=&snew=0&pnt=Normal%20table&code=24125)
# Northwest Africa 7701 - https://www.lpi.usra.edu/meteor/metbull.php?sea=Nort
#hwest+Africa+7701&sfor=names&ants=&nwas=&falls=&valids=&stype=contains&lrec=50&
#map=ge&browse=&country=All&srt=name&categ=All&mblist=All&rect=&phot=&snew=0&pnt=
#Normal%20table&code=57150
#
# Meteorites with out of bounds lat/lng
# Meridiani Planum - https://www.lpi.usra.edu/meteor/metbull.php?sea=Meridiani+Planu
#m&sfor=names&ants=&nwas=&falls=&valids=&stype=contains&lrec=50&map=ge&browse=&country
#=All&srt=name&categ=All&mblist=All&rect=&phot=&snew=0&pnt=Normal%20table&code=32789
