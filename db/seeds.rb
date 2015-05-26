# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

latitudes = [-37.83, -37.67, -38.03, -38.36, -37.72, -37.73, -37.91, -37.87, -38.15, -38.17, -37.86, -37.98, -38.10, -38.46, -37.87, -37.91, -38.31, -37.86, -37.74]		
longitudes = [144.98, 144.83, 144.48, 145.18, 145.41, 144.91, 144.93, 145.35, 145.12, 144.38, 144.76, 145.10, 144.54, 145.31, 145.26, 144.13, 144.80, 144.96, 145.10]
places = ['Melbourne (Olympic Park)','Melbourne Airport','Avalon','Cerberus','Coldstream','Essendon Airport','Fawkner Beacon','Ferny Creek','Frankston','Geelong Racecourse','Laverton','Moorabbin Airport','Point Wilson','Rhyll','Scoresby','Sheoaks','South Channel Island','St Kilda Harbour RMYS','Viewbank']
codes = ['melbourne-olympic-park','melbourne-airport','avalon','cerberus','coldstream', 'essendon-airport','fawkner-beacon','ferny-creek','frankston','geelong-racecourse','laverton','moorabbin-airport','point-wilson','rhyll','scoresby','sheoaks','south-channel-island','st-kilda-harbour-rmys','viewbank']

codes.each_with_index do |code, index|
	location = Location.new
	location.location_id = code
	location.lat = latitudes[index]
	location.long = longitudes[index]
	location.save 
end

locations = Location.all



locations.each do |place|
    datum = Datum.new
    datum.set_data(place)
    datum.save
  end