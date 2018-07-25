# Data cleaning for meteorite app
library(dplyr)

##### DATA CLEANING #####
meteorites = read.csv("./data/meteorite_landings.csv")

# Update some column names
names(meteorites)[names(meteorites) == 'reclat'] <- 'lat'
names(meteorites)[names(meteorites) == 'reclong'] <- 'long'
names(meteorites)[names(meteorites) == 'recclass'] <- 'class'
names(meteorites)[names(meteorites) == 'mass..g.'] <- 'mass'

# remove commas from mass numbers
meteorites$mass = as.character(meteorites$mass)
meteorites$mass = gsub(pattern = ",", replacement = "",
                       x = meteorites$mass)

# Convert mass and year to numerics
meteorites$mass = as.numeric(meteorites$mass)
meteorites$year = as.numeric(substr(meteorites$year, 7,10))

# Remove any nonsense points and unnecessary columns
meteorites = filter(meteorites, year < 2018)
meteorites = filter(meteorites, long > -180 & long < 180)
meteorites = filter(meteorites, lat > -90 & lat < 90)
meteorites = mutate(meteorites, keep = ifelse(lat ==0 & long ==0, 
                                              "drop", "keep"))
meteorites = filter(meteorites, keep == "keep")
meteorites = select(meteorites, -GeoLocation, -keep)

# Write to output
write.csv(x = meteorites, "cleaned_meteorites.csv")
