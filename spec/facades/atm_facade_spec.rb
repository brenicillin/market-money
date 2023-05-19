require 'rails_helper'

RSpec.describe 'ATM Facade' do
  describe 'it initializes with a market_id' do
    it 'exists and has attributes' do
      atm_facade = AtmFacade.new(1)

      expect(atm_facade).to be_a(AtmFacade)
      expect(atm_facade.market_id).to eq(1)
    end
  end

  describe 'instance methods' do
    it '#closest_atms' do
      market = create(:market, lat: 32.628508, lon: -117.067718)
      atm_facade = AtmFacade.new(market.id)

      expect(atm_facade.closest_atms).to be_an(Array)
      expect(atm_facade.closest_atms).to all be_a(Atm)
    end
  end
end