class Api::V0::VendorsController < ApplicationController
  def index
    if Market.exists?(params[:market_id])
      @market = Market.find(params[:market_id])
      render json: VendorSerializer.new(@market.vendors)
    else
      render json: { errors: [{ detail: "Couldn't find Market with 'id'=#{params[:market_id]}."}] }, status: 404
    end
  end
end