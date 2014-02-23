class AddIsDefaultToExchanges < ActiveRecord::Migration
  def change
    add_column :exchanges, :is_default, :boolean, default: false
  end
end
