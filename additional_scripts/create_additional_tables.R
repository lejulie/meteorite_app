library(tidyr)
library(dplyr)

# Read the data
meteorites = read.csv("./data/meteorites_with_countries.csv")
meteorites = select(meteorites, -X)
meteorites$lat_pretty = format(round(meteorites$lat, 3), nsmall=3)
meteorites$long_pretty = format(round(meteorites$long, 3), nsmall=3)
 
# Aggregate data by class
class_avg_mass = meteorites %>% 
  group_by(class) %>% 
  summarise(avg_mass = mean(mass))

class_fell_found = meteorites %>%
  group_by(class, fall) %>%
  summarise(count = n()) %>%
  spread(key = fall, value = count)

class_summary = merge(class_avg_mass, class_fell_found)

class_summary[is.na(class_summary)] = 0
class_summary$avg_mass = round(class_summary$avg_mass,0)

class_total = sum(class_summary$Fell) + sum(class_summary$Found)
class_summary$total_row = class_summary$Fell + class_summary$Found
class_summary$pct_of_all = 
  round(class_summary$total_row/class_total*100,3)

# Write to a csv file
write.csv(x = class_summary, file = "class_summary_table.csv")

# Aggregate data by country

country_avg_mass = meteorites %>% 
  group_by(country) %>% 
  summarise(avg_mass = mean(mass))

country_fell_found = meteorites %>%
  group_by(country, fall) %>%
  summarise(count = n()) %>%
  spread(key = fall, value = count)

country_summary = merge(country_avg_mass, country_fell_found)

country_summary[is.na(country_summary)] = 0
country_summary$avg_mass = round(country_summary$avg_mass,0)

country_total = sum(country_summary$Fell) + sum(country_summary$Found)
country_summary$total_row = country_summary$Fell + country_summary$Found
country_summary$pct_of_all = 
  round(country_summary$total_row/country_total*100,3)

# Write to a csv file
write.csv(x = country_summary, file = "country_summary_table.csv")
