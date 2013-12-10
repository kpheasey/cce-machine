class AddMarketForVircurex < ActiveRecord::Migration
  def change
    vircurex = Exchange::VIRCUREX.new
    vircurex.name = 'Vircurex'
    vircurex.save

    em = ExchangeMarket.new
    em.market = Market.first
    em.exchange = vircurex
    em.code = 'USD'
    em.save
  end
end
