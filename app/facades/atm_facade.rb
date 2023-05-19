require './app/services/atm_service'

class AtmFacade
  attr_reader :market_id

  def initialize(market_id)
    @market_id = market_id
  end

  def closest_atms
    market = Market.find(@market_id)
    atms = AtmService.nearby_atms(market.lat, market.lon)[:results]
    atms.map do |atm|
      Atm.new(atm)
    end
  end
end