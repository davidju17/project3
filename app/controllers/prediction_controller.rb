class PredictionController < ApplicationController
  def retrieve_prediction
  end

  def index
  	@hola=params[:code]
  	@hola2=params[:date]
  end

end
