require 'rails_helper'

RSpec.describe 'Markets API' do
  it 'sends a list of markets' do
    create_list(:market, 10)

    get '/api/v0/markets'

    expect(response).to be_successful

    markets = JSON.parse(response.body, symbolize_names: true)[:data]
    test_market = markets.first[:attributes]
    expect(markets.count).to eq(10)

    markets.each do |market|
      expect(market).to have_key(:id)
      expect(market[:id]).to be_an(String)
      expect(market).to have_key(:type)
      expect(market[:type]).to eq('market')
      expect(market).to have_key(:attributes)
      expect(market[:attributes]).to be_a(Hash)
    end

    expect(test_market).to have_key(:name)
    expect(test_market[:name]).to be_a(String)
    expect(test_market).to have_key(:street)
    expect(test_market[:street]).to be_a(String)
    expect(test_market).to have_key(:city)
    expect(test_market[:city]).to be_a(String)
    expect(test_market).to have_key(:county)
    expect(test_market[:county]).to be_a(String)
    expect(test_market).to have_key(:state)
    expect(test_market[:state]).to be_a(String)
    expect(test_market).to have_key(:zip)
    expect(test_market[:zip]).to be_a(String)
    expect(test_market).to have_key(:lat)
    expect(test_market[:lat]).to be_a(String)
    expect(test_market).to have_key(:lon)
    expect(test_market[:lon]).to be_a(String)
  end

  it 'can get one market by its id' do
    id = create(:market).id

    get "/api/v0/markets/#{id}"

    expect(response).to be_successful

    market = JSON.parse(response.body, symbolize_names: true)[:data]
    market_attributes = market[:attributes]

    expect(market_attributes).to have_key(:name)
    expect(market_attributes[:name]).to be_a(String)
    expect(market_attributes).to have_key(:street)
    expect(market_attributes[:street]).to be_a(String)
    expect(market_attributes).to have_key(:city)
    expect(market_attributes[:city]).to be_a(String)
    expect(market_attributes).to have_key(:county)
    expect(market_attributes[:county]).to be_a(String)
    expect(market_attributes).to have_key(:state)
    expect(market_attributes[:state]).to be_a(String)
    expect(market_attributes).to have_key(:zip)
    expect(market_attributes[:zip]).to be_a(String)
    expect(market_attributes).to have_key(:lat)
    expect(market_attributes[:lat]).to be_a(String)
    expect(market_attributes).to have_key(:lon)
    expect(market_attributes[:lon]).to be_a(String)
  end

  it 'market by id sad path' do

    get "/api/v0/markets/123123123123"

    body = JSON.parse(response.body, symbolize_names: true)
    error_detail = body[:errors].first[:detail]

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    expect(body).to have_key(:errors)

    expect(error_detail).to eq("Couldn't find market with 'id'=123123123123.")
  end
end