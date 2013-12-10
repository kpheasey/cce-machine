class SwitchMarketAndExchangeTableNamesPart2 < ActiveRecord::Migration
  def change
    rename_table :exchanges_temp, :exchanges
  end
end
