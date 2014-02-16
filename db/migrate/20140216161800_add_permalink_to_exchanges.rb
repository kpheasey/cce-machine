class AddPermalinkToExchanges < ActiveRecord::Migration
  def change
    add_column :exchanges, :permalink, :string
    add_index :exchanges, :permalink, unique: true
    add_column :exchanges, :slug, :string
    add_index :exchanges, :slug, unique: true
  end
end
