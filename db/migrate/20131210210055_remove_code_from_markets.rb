class RemoveCodeFromMarkets < ActiveRecord::Migration
  def up
    remove_column :markets, :code
  end

  def down
    add_column :markets, :code, :string
  end
end
