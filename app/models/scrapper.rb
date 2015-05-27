URL = 'http://www.bom.gov.au/vic/observations/melbourne.shtml'
API_KEY = 'fca168eabed1ae61ce4569fd4681f8b1'
BASE_URL = 'https://api.forecast.io/forecast'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
CARDINAL_TO_DEGREES = {"CALM"=>0, "N"=>0, "NNE"=>22, "NE"=>45, "ENE"=>67, "E"=>90, "ESE"=>112, "SE"=>135, "SSE"=>157, "S"=>180, "SSW"=>202, "SW"=>225, "WSW"=>247, "W"=>270, "WNW"=>292, "NW"=>315, "NNW"=>337}
FIELDS=['temp','wind obs-wind-dir','wind obs-wind-spd-kph','rainsince9am']

require 'nokogiri'
require 'open-uri'
require 'json'

class Scrapper < ActiveRecord::Base

	def read_bom(location)		
		doc = Nokogiri::HTML(open(URL))
		temp_array = []
		elements = {}

		FIELDS.each_with_index do |category, index|
			s = '#tMELBOURNE tbody td[headers='+'"obs-'+ category + ' obs-station-' + location + '"]'
			temp_array[index] = doc.css(s).text
		end

		elements[:temp]= temp_array[0]
		elements[:wind_dir]= CARDINAL_TO_DEGREES[temp_array[1]]
		elements[:wind_speed]= temp_array[2]
		elements[:rain]= temp_array[3]

		return elements
	end
end
