require 'rails_helper'

RSpec.describe 'Market Nearby ATMs' do
  describe 'happy path' do
    it 'returns a list of nearby ATMs' do
      market = create(:market, lat: 39.7392, lon: -104.9903)

      get "/api/v0/markets/#{market.id}/nearest_atms"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(data.count).to eq(10)

      data.each do |atm|
        expect(atm).to have_key(:attributes)
        expect(atm[:attributes]).to be_a(Hash)
        expect(atm[:attributes]).to have_key(:name)
        expect(atm[:attributes]).to have_key(:address)
        expect(atm[:attributes]).to have_key(:distance)
        expect(atm[:attributes]).to have_key(:lat)
        expect(atm[:attributes]).to have_key(:lon)
      end
    end
  end

  describe 'sad path' do
    it 'returns an error if market does not exist' do
      get "/api/v0/markets/0/nearest_atms"
      
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end
  end
end