require 'rails_helper'

RSpec.describe Atm do
  describe 'initialize' do
    it 'exists' do
      atm_params = {
        name: "Test ATM",
        dist: 0.1,
        address:
         {freeformAddress:"718 Alpine Avenue"},
        position: {
          lat: 32.628508,
          lon: -117.067718}
      }
      atm = Atm.new(atm_params)

      expect(atm).to be_a(Atm)
      expect(atm.id).to eq(nil)
      expect(atm.name).to eq("Test ATM")
      expect(atm.address).to eq("718 Alpine Avenue")
      expect(atm.lat).to eq(32.628508)
      expect(atm.lon).to eq(-117.067718)
      expect(atm.distance).to eq(0.1)
    end
  end
end