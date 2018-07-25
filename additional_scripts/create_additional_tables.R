library(tidyr)
library(dplyr)

# Read the data
meteorites = read.csv("./data/meteorites_with_countries.csv")
meteorites = select(meteorites, -X)
meteorites = filter(meteorites, is.na(mass) == FALSE)
 
# Aggregate data by class
class_avg_mass = meteorites %>% 
  group_by(class) %>% 
  summarise(avg_mass = round(mean(mass),2),
            total_mass= round(sum(mass),2))

class_fell_found = meteorites %>%
  group_by(class, fall) %>%
  summarise(count = n()) %>%
  spread(key = fall, value = count)

class_summary = merge(class_avg_mass, class_fell_found)

class_summary$Fell[is.na(class_summary$Fell)] = 0
class_summary$Found[is.na(class_summary$Found)] = 0

class_total = sum(class_summary$Fell) + sum(class_summary$Found)
class_summary$total_row = class_summary$Fell + class_summary$Found
class_summary$pct_of_all = 
  round(class_summary$total_row/class_total*100,3)
class_summary = filter(class_summary, avg_mass>0)

# Write to a csv file
write.csv(x = class_summary, file = "class_summary_table.csv")

# Aggregate data by country

country_avg_mass = meteorites %>% 
  group_by(country) %>% 
  summarise(avg_mass = round(mean(mass, na.rm = TRUE),2),
            total_mass= round(sum(mass, na.rm = TRUE),2))

country_fell_found = meteorites %>%
  group_by(country, fall) %>%
  summarise(count = n()) %>%
  spread(key = fall, value = count)

country_summary = merge(country_avg_mass, country_fell_found)

country_summary$Fell[is.na(country_summary$Fell)] = 0
country_summary$Found[is.na(country_summary$Found)] = 0

country_total = sum(country_summary$Fell) + sum(country_summary$Found)
country_summary$total_row = country_summary$Fell + country_summary$Found
country_summary$pct_of_all = 
  round(country_summary$total_row/country_total*100,3)

# Write to a csv file
write.csv(x = country_summary, file = "country_summary_table.csv")
