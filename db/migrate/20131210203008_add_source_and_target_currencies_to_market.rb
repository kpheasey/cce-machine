class AddSourceAndTargetCurrenciesToMarket < ActiveRecord::Migration
  def change
    add_column :markets, :source_id, :integer
    add_column :markets, :target_id, :integer
  end
end
