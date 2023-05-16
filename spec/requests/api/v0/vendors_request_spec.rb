require 'rails_helper'

RSpec.describe 'Markets API' do
  before(:each) do
    create_list(:market, 10)
    create_list(:vendor, 10)
    create_list(:market_vendor, 10)
  end
  describe 'happy path' do
    it 'sends a list of vendors' do

    end
  end
end