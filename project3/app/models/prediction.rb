class Prediction < ActiveRecord::Base
	def predict_by_coordinates(lat, long, period)
		location = get_closest_locations(lat, long) #Modify method!, now its returning only one for testing purposes
		#seguire trabajando con solo un location por el momento
		data = location_data(location, period)

		rain_model = find_model(data[:rain])
		wind_dir_model = find_model(data[:wind_dir])
		wind_speed_model = find_model(data[:wind_speed])
		temperature_model = find_model(data[:temperature])

		a = predict(rain_model, period)
		b = predict(wind_dir_model, period)
		c = predict(wind_speed_model, period)
		puts d = predict(temperature_model, period)

		return [a,b,c,d]
	end

	def location_data(location, period)
		
		raw_data = {:rain=>[],:wind_dir=>[],:wind_speed=>[],:temperature=>[]}

		records = location.data.last(period)

		records.each do |record|
			raw_data[:rain] << record.rainfall
			raw_data[:wind_dir] << record.wind_direction.to_f
			raw_data[:wind_speed] << record.wind_speed
			raw_data[:temperature] << record.temperature
		end

		return raw_data

	end

	def find_model(data)
		regression = Regression.new
		return regression.best_fit(data)
	end

	def predict(model, period)
		predictions = []
		val = model[:samples_size]
		x = (val..val+(period/10)).to_a

		case model[:type]
		when 'linear'
			(0..period/10).to_a.each {|i| predictions[i] = model[:coeffs][1]*x[i] + model[:coeffs][0]}
		when 'polynomial'
			(0..period/10).to_a.each do |i|
				predictions[i] = (0..model[:degree]).reduce(0) {|sum, j| sum + (model[:coeffs][j]*(x[i]**j))}
			end
		when 'exponential'
			(0..period/10).to_a.each {|i| predictions[i] = model[:coeffs][0]*(Math::E**(model[:coeffs][1]*x[i]))}
		when 'logarithmic'
			(0..period/10).to_a.each {|i| predictions[i] = model[:coeffs][0] + (model[:coeffs][1]*Math::log(x[i]))}
		end	

		return predictions	
	end

	def get_closest_locations(lat, long)
		locations = Location.all
		return locations.find {|location| location.lat == lat && location.long == long}
	end
end
