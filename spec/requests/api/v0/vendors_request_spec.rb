require 'rails_helper'

RSpec.describe 'Markets API' do
  before(:each) do
    @market_1 = create(:market)
    @market_2 = create(:market)
    vendor_1 = create(:vendor)
    vendor_2 = create(:vendor)
    vendor_3 = create(:vendor)
    MarketVendor.create(market_id: @market_1.id, vendor_id: vendor_1.id)
    MarketVendor.create(market_id: @market_1.id, vendor_id: vendor_2.id)
    MarketVendor.create(market_id: @market_2.id, vendor_id: vendor_3.id)
    MarketVendor.create(market_id: @market_2.id, vendor_id: vendor_1.id)
  end
  describe 'happy path' do
    it 'sends a list of vendors' do
      get "/api/v0/markets/#{@market_1.id}/vendors"

      expect(response).to be_successful

      body = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(body.count).to eq(2)

      body.each do |vendor|
        expect(vendor).to have_key(:id)
        expect(vendor[:id]).to be_an(String)

        expect(vendor).to have_key(:type)
        expect(vendor[:type]).to eq('vendor')

        expect(vendor).to have_key(:attributes)
        expect(vendor[:attributes]).to be_a(Hash)

        attributes = vendor[:attributes]

        expect(attributes).to have_key(:name)
        expect(attributes).to have_key(:description)
        expect(attributes).to have_key(:contact_name)
        expect(attributes).to have_key(:contact_phone)
        expect(attributes).to have_key(:credit_accepted)
      end
    end
  end

  describe 'sad path' do
    it 'returns an error if market does not exist' do
      get "/api/v0/markets/0/vendors"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      
      body = JSON.parse(response.body, symbolize_names: true)
      error = body[:errors].first
      
      expect(error[:detail]).to eq("Couldn't find Market with 'id'=0.")
    end
  end

  describe 'show happy path' do
    it 'sends a single vendor' do
      create(:vendor)
      
      get "/api/v0/vendors/#{Vendor.last.id}"
      
      expect(response).to be_successful
      
      body = JSON.parse(response.body, symbolize_names: true)[:data]
      attributes = body[:attributes]
      
      expect(body).to have_key(:id)
      expect(body[:id]).to be_an(String)
      expect(attributes).to have_key(:name)
      expect(attributes).to have_key(:description)
      expect(attributes).to have_key(:contact_name)
      expect(attributes).to have_key(:contact_phone)
      expect(attributes).to have_key(:credit_accepted)
    end
  end

  describe 'show sad path' do
    it 'returns an error if vendor does not exist' do
      get "/api/v0/vendors/0"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      body = JSON.parse(response.body, symbolize_names: true)
      error = body[:errors].first

      expect(error[:detail]).to eq("Couldn't find Vendor with 'id'=0.")
    end
  end
end