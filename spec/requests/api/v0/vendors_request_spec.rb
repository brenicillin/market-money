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
  describe 'index happy path' do
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

  describe 'index sad path' do
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

  describe 'create happy path' do
    it 'creates a new vendor' do
      vendor_params = {
        name: 'Buzzy Bees',
        description: 'local honey and wax products',
        contact_name: 'Berly Couwer',
        contact_phone: '8389928383',
        credit_accepted: false
      }

      post '/api/v0/vendors', params: { vendor: vendor_params }

      expect(response).to be_successful
      expect(response.status).to eq(201)

      body = JSON.parse(response.body, symbolize_names: true)[:data]
      vendor = body[:attributes]

      expect(body).to have_key(:id)
      expect(body[:id]).to be_an(String)

      expect(body).to have_key(:type)
      expect(body[:type]).to eq('vendor')

      expect(vendor).to have_key(:name)
      expect(vendor[:name]).to eq(vendor_params[:name])

      expect(vendor).to have_key(:description)
      expect(vendor[:description]).to eq(vendor_params[:description])

      expect(vendor).to have_key(:contact_name)
      expect(vendor[:contact_name]).to eq(vendor_params[:contact_name])

      expect(vendor).to have_key(:contact_phone)
      expect(vendor[:contact_phone]).to eq(vendor_params[:contact_phone])

      expect(vendor).to have_key(:credit_accepted)
      expect(vendor[:credit_accepted]).to eq(vendor_params[:credit_accepted])
    end
  end

  describe 'create sad path' do
    it 'returns an error if name is missing' do
      vendor_params = {
        name: '',
        description: 'local honey and wax products',
        contact_name: 'Berly Couwer',
        contact_phone: '8389928383',
        credit_accepted: false
      }

      post '/api/v0/vendors', params: { vendor: vendor_params }

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      body = JSON.parse(response.body, symbolize_names: true)
    end
  end

  describe 'destroy happy path' do
    it 'deletes a vendor' do
      destroy_me = create(:vendor)

      delete "/api/v0/vendors/#{destroy_me.id}"

      expect(response).to be_successful
      expect(response.status).to eq(204)

      expect(Vendor.where(id: destroy_me.id)).to eq([])
    end
  end

  describe 'destroy sad path' do
    it 'returns an error if vendor does not exist' do
      delete "/api/v0/vendors/0"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end
  end

  describe 'update happy path' do
    it 'updates a vendor' do
      vendor = create(:vendor)
      vendor_params = {
        name: 'Buzzy Bees',
        description: 'local honey and wax products',
        contact_name: 'Berly Couwer',
        contact_phone: '8389928383',
        credit_accepted: false
      }

      patch "/api/v0/vendors/#{vendor.id}", params: { vendor: vendor_params }

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(Vendor.last.name).to eq(vendor_params[:name])
      expect(Vendor.last.description).to eq(vendor_params[:description])
      expect(Vendor.last.contact_name).to eq(vendor_params[:contact_name])
      expect(Vendor.last.contact_phone).to eq(vendor_params[:contact_phone])
      expect(Vendor.last.credit_accepted).to eq(vendor_params[:credit_accepted])
    end
  end

  describe 'update sad path' do
    it 'returns an error if vendor does not exist' do
      patch "/api/v0/vendors/0"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end

    it 'returns an error if name is missing' do
      vendor = create(:vendor)
      vendor_params = {
        name: '',
        description: 'local honey and wax products',
        contact_name: 'Berly Couwer',
        contact_phone: '8389928383',
        credit_accepted: false
      }

      patch "/api/v0/vendors/#{vendor.id}", params: { vendor: vendor_params }
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(body).to have_key(:errors)
      expect(body[:errors].first[:detail]).to eq("Validation failed: Missing required field")
    end
  end
end