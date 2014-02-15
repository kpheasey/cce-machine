class SwitchMarketAndExchangeTableNamesPart1 < ActiveRecord::Migration
  def change
    rename_table :markets, :exchanges_temp
    rename_table :exchanges, :markets
  end
end
