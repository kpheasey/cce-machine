class CreateMarket < ActiveRecord::Migration
  def up
    create_table :markets do |t|
      t.string :type
      t.string :name
      t.string :code
    end
  end

  def down
    drop_table :markets
  end
end
