require 'rails_helper'

RSpec.describe 'Markets API' do
  describe 'it can search for markets by name happy path' do
    it 'can search by name' do
      create_list(:market, 3)

      get "/api/v0/markets/search", params: { name: "Market" }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      markets = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(markets.count).to eq(0)

      get "/api/v0/markets/search", params: { name: "#{Market.first.name}" }

      markets_2 = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(markets_2.count).to eq(1)
    end

    it 'can search by state' do
      create_list(:market, 3)

      get "/api/v0/markets/search", params: { state: "#{Market.first.state}" }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      market = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(market.count).to eq(1)
    end

    it 'can search by state and city' do
      create_list(:market, 3)

      get "/api/v0/markets/search", params: { state: "#{Market.first.state}", city: "#{Market.first.city}" }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      market = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(market.count).to eq(1)
    end

    it 'can search by state, city, and name' do
      create_list(:market, 3)

      get "/api/v0/markets/search", params: { state: "#{Market.first.state}", city: "#{Market.first.city}", name: "#{Market.first.name}" }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      market = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(market.count).to eq(1)
    end

    it 'can search by state and name' do
      create_list(:market, 3)

      get "/api/v0/markets/search", params: { state: "#{Market.first.state}", name: "#{Market.first.name}" }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      market = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(market.count).to eq(1)
    end
  end

  describe 'it can search for markets by name sad path' do
    it 'returns an error if disallowed params are passed - only city' do
      create_list(:market, 3)

      get "/api/v0/markets/search", params: { city: "#{Market.first.city}" }

      expect(response).to_not be_successful
      expect(response.status).to eq(422)

      body = JSON.parse(response.body, symbolize_names: true)

      expect(body[:errors].first[:detail]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
    end

    it 'returns an error if disallowed params are passed - city and name' do
      create_list(:market, 3)

      get "/api/v0/markets/search", params: { city: "#{Market.first.city}", name: "#{Market.first.name}" }

      expect(response).to_not be_successful
      expect(response.status).to eq(422)

      body = JSON.parse(response.body, symbolize_names: true)
      
      expect(body[:errors].first[:detail]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
    end
  end
end