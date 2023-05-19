class Api::V0::AtmController < ApplicationController
  def index
    if Market.exists?(params[:market_id])
      @market = Market.find(params[:market_id])
      @atms = AtmFacade.new(params[:market_id]).closest_atms
      response = render json: AtmSerializer.new(@atms), status: 200
    else
      render json: { errors: "Couldn't find Market with 'id'=#{params[:market_id]}." }, status: 404
    end
  end
end