class Api::V0::MarketSearchController < ApplicationController
  before_action :invalid_params, only: [:index]

  def index
    @markets = MarketSearchFacade.search_markets(params[:name], params[:city], params[:state])
    render json: MarketSerializer.new(@markets)
  end

  private
  # Disallowed params:
  def invalid_params
    return invalid if city_and_name || city_only
  end
  
  def city_only
    params[:city].present? && params[:name].blank? && params[:state].blank?
  end

  def city_and_name
    params[:city].present? && params[:name].present? && params[:state].blank?
  end

  def invalid
    render json: { errors: [{ detail: "Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint."}] }, status: 422
  end
end