class AddIsDefaultToMarkets < ActiveRecord::Migration
  def up
    add_column :markets, :is_default, :boolean, default: true
  end

  def down
    remove_column :markets, :is_default
  end
end
