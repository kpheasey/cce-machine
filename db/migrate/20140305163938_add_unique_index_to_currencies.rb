class AddUniqueIndexToCurrencies < ActiveRecord::Migration
  def up
    add_index :currencies, :code, unique: true
  end

  def down
    remove_index :currencies, :code
  end
end
