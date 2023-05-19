require 'rails_helper'

RSpec.describe 'ATM Service' do
  describe 'class methods' do
    it '.nearby_atms' do
        response = AtmService.nearby_atms(32.628508, -117.067718)[:results].first
        # require 'pry'; binding.pry
        expect(response).to be_a(Hash)
        expect(response[:position]).to have_key(:lat)
        expect(response[:position]).to have_key(:lon)
        expect(response[:address]).to have_key(:freeformAddress)
        expect(response).to have_key(:dist)
    end
  end
end