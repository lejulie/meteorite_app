# Data cleaning for meteorite app

##### DATA CLEANING #####

# Update some column names
names(meteorites)[names(meteorites) == 'reclat'] <- 'lat'
names(meteorites)[names(meteorites) == 'reclong'] <- 'long'
names(meteorites)[names(meteorites) == 'recclass'] <- 'class'
names(meteorites)[names(meteorites) == 'mass..g.'] <- 'mass'

# Convert mass and year to numerics
meteorites$mass = as.numeric(meteorites$mass)
meteorites$year = as.numeric(substr(meteorites$year, 7,10))

# Remove any nonsense points and unnecessary columns
meteorites = filter(meteorites, year < 2018)
meteorites = filter(meteorites, long > -180 & long < 180)
meteorites = filter(meteorites, lat > -90 & lat < 90)
meteorites = mutate(meteorites, keep = ifelse(lat ==0 & long ==0, "drop", "keep"))
meteorites = filter(meteorites, keep == "keep")
meteorites = select(meteorites, -GeoLocation, -keep)

# remove points missing lat/lng
meteorites = meteorites[complete.cases(meteorites),]