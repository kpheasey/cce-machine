class AddPermalinkToMarkets < ActiveRecord::Migration
  def change
    add_column :markets, :permalink, :string
    add_index :markets, :permalink, unique: true
    add_column :markets, :slug, :string
    add_index :markets, :slug, unique: true
  end
end
