class Api::V0::MarketVendorsController < ApplicationController
  def create
    if Market.exists?(params[:market_id]) && Vendor.exists?(params[:vendor_id])
      if !MarketVendor.exists?(vendor_id: params[:vendor_id], market_id: params[:market_id])
        render json: MarketVendor.create(vendor_id: params[:vendor_id], market_id: params[:market_id]), status: 201
      else
        render json: { errors: [{ detail: "Vendor already exists at this market."}] }, status: 422
      end
    else 
      render json: { errors: [{ detail: "Couldn't find Market with 'id'=#{params[:market_id]}."}] }, status: 404
    end
  end

  def destroy
    market_vendor = MarketVendor.find_by(market_id: params[:market_id], vendor_id: params[:vendor_id])
    if market_vendor
      market_vendor.destroy
      render json:  {}, status: 204
    else
      render json: { errors: [{ detail: "Couldn't find MarketVendor with 'market_id'=#{params[:market_id]} AND 'vendor_id'=#{params[:vendor_id]}."}] }, status: 404
    end
  end
end