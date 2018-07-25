# Reverse geocode meteorite locations
import reverse_geocoder as rg
import csv

with open('cleaned_ids_and_geocodes.csv', 'r') as csvfile:
 	rdr = csv.reader(csvfile, delimiter=',', quotechar='"')
 	for line in rdr:
 		# print(line[1])
 		id = line[0]
 		coords = line[1]
 		tup = tuple(coords.replace('(','').replace(')','').split(','))
 		results = rg.search(tup)
 		country = results[0]['cc']
 		print("%s, %s" % (id, country))
