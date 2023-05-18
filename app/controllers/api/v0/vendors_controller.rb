class Api::V0::VendorsController < ApplicationController
  def index
    if Market.exists?(params[:market_id])
      @market = Market.find(params[:market_id])
      render json: VendorSerializer.new(@market.vendors)
    else
      render json: { errors: [{ detail: "Couldn't find Market with 'id'=#{params[:market_id]}."}] }, status: 404
    end
  end

  def show
    if Vendor.exists?(params[:id])
      render json: VendorSerializer.new(Vendor.find(params[:id]))
    else
      render json: { errors: [{ detail: "Couldn't find Vendor with 'id'=#{params[:id]}."}] }, status: 404
    end
  end

  def create
    vendor = Vendor.new(vendor_params)
    if vendor.save
      render json: VendorSerializer.new(vendor), status: 201
    else
      render json: { errors: vendor.errors }, status: 400
    end
  end

  def update
    if Vendor.exists?(params[:id])
      vendor = Vendor.find(params[:id])
      if vendor.update(vendor_params)
        render json: VendorSerializer.new(vendor), status: 200
      else
        render json: { errors: [{detail: "Validation failed: Missing required field"}] }, status: 400
      end
    else
      render json: { errors: [{ detail: "Couldn't find Vendor with 'id'=#{params[:id]}."}] }, status: 404
    end
  end

  def destroy
    if Vendor.exists?(params[:id])
      render json: Vendor.destroy(params[:id]), status: 204
    else
      render json: { errors: [{ detail: "Couldn't find Vendor with 'id'=#{params[:id]}."}] }, status: 404
    end
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end