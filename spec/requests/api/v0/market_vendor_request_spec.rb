require 'rails_helper'

RSpec.describe "MarketVendor Requests" do
  before(:each) do
    @market = create(:market)
    @vendor = create(:vendor)
  end

  describe 'create a market_vendor happy path' do
    it 'adds a vendor to a market' do
      post "/api/v0/market_vendors", params: { market_id: @market.id, vendor_id: @vendor.id }

      expect(response).to be_successful
      expect(response.status).to eq(201)
      
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:market_id]).to eq(@market.id)
      expect(body[:vendor_id]).to eq(@vendor.id)
      expect(@market.vendors.count).to eq(1)
      expect(@market.vendors.first.id).to eq(@vendor.id)
    end
  end

  describe 'create a market_vendor sad path' do
    it 'returns an error if market_vendor already exists' do
      MarketVendor.create(market_id: @market.id, vendor_id: @vendor.id)

      post "/api/v0/market_vendors", params: { market_id: @market.id, vendor_id: @vendor.id }
      
      expect(response).to_not be_successful
      expect(response.status).to eq(422)
    end

    it 'returns an error if market does not exist' do
      post "/api/v0/market_vendors", params: { market_id: 0, vendor_id: @vendor.id }

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end

    it 'returns an error if vendor does not exist' do
      post "/api/v0/market_vendors", params: { market_id: @market.id, vendor_id: 0 }

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end
  end

  describe 'delete a market_vendor happy path' do
    it 'deletes a market_vendor' do
      market = create(:market)
      vendor_1 = create(:vendor)
      vendor_2 = create(:vendor)
    
      mv_1 = MarketVendor.create(market_id: market.id, vendor_id: vendor_1.id)
      mv_2 = MarketVendor.create(market_id: market.id, vendor_id: vendor_2.id)

      get "/api/v0/markets/#{market.id}/vendors"

      vendors = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(vendors.count).to eq(2)
      
      delete "/api/v0/market_vendors/", params: { market_id: market.id, vendor_id: vendor_1.id }


      expect(response).to be_successful
      expect(response.status).to eq(204)

      get "/api/v0/markets/#{market.id}/vendors"

      new_vendors = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(new_vendors.count).to eq(1)
    end
  end

  describe 'delete a market_vendor sad path' do
    it 'returns an error if market_vendor does not exist' do
      delete "/api/v0/market_vendors/", params: { market_id: 0, vendor_id: 0}

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      body = JSON.parse(response.body, symbolize_names: true)

      expect(body[:errors][0][:detail]).to eq("Couldn't find MarketVendor with 'market_id'=0 AND 'vendor_id'=0.")
    end
  end
end