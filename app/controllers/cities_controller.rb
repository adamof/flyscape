class CitiesController < ApplicationController
  def near
    cities = City.near([params[:lat], params[:lng]], params[:range] || 10)
    render json: cities
  end
end