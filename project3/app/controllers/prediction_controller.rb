class PredictionController < ApplicationController
  def by_lat_long
  	@lat = params[:lat]
  	@long = params[:long]
  	@period = params[:period]
  end

  def by_postcode
  	@postcode = params[:post_code]
  	@period = params[:period]
  end
end
