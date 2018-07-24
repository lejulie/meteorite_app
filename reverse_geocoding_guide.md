# Reverse Geocoding to Get Countries from Lat/Longs

## Why Reverse Geocoding

The [raw meteorite data set](https://data.nasa.gov/Space-Science/Meteorite-Landings/gh4g-9sfh) provides geocoordinates for each meteorite, however it doesn't equate these to the countries where they were located.  Since I was interested in how metrics like count of meteorites roll up by country, I needed to reverse geocode the countries myself.  To do this, I used [this](https://github.com/thampiman/reverse-geocoder) offline reverse geocoder, by [Ajay Thampi](https://github.com/thampiman).

## Steps

1. Extracted the ids and geocodes only from the data set as a csv, using R.

1. Used the attached `rev_geocode.py` script to iterate through the csv file and print out the associated country code for each id.

1. Created an additional csv file to represent the mapping between country codes and full country names, based on the mapping [here](http://www.geonames.org/countries/).

1. Mapped full country names to ids, and then to the meteorite data using R (`map_countries_to_ids.R`).