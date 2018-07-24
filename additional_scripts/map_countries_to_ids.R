library(dplyr)

meteorites = read.csv("./meteorite_app/data/cleaned_meteorites.csv")
meteorites = select(meteorites, -X, -nametype)
meteorites$lat_pretty = format(round(meteorites$lat, 3), nsmall=3)
meteorites$long_pretty = format(round(meteorites$long, 3), nsmall=3)

countries = read.csv("./countries/country_codes2.csv", 
                     header = FALSE, na.strings = FALSE)
countries <- data.frame(lapply(countries, as.character), 
                        stringsAsFactors=FALSE)
names(countries) = c("id","cc")

# strip the whitespace from cc in countries
fn = function(str){gsub(pattern = " ", replacement = "", x = str)}
clean_cc = sapply(X = countries$cc, FUN = fn)

#replace NA with NAM to avoid confusion
clean_cc = gsub(pattern = "NA", replacement = "NAM", x = clean_cc)
countries$cc = clean_cc

# set up data frame for map
map = read.csv("./countries/map_country_codes.csv", na.strings = FALSE)
map = data.frame(lapply(map, as.character), stringsAsFactors=FALSE)
map_cc = gsub(pattern = "NA", replacement = "NAM", x = map$cc)
map$cc = map_cc

# Left join countries and map, then rename names to "country"
countries_merged = merge(x = countries, y = map, by = "cc", all.x = TRUE)
full_countries = select(countries_merged, id, name)
names(full_countries) = c("id","country")

# Left join meteorites and full_countries
meteorites_merged = merge(x = meteorites, y = full_countries, by = "id", 
                          all.x = TRUE)

# Write the output to a new csv
getwd()
write.csv(meteorites_merged, "meteorites_with_countries.csv")
