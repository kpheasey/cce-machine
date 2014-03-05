class AdduniqueIndexToSourceTargetOfMarket < ActiveRecord::Migration
  def change
    change_column :markets, :is_default, :boolean, default: false
    add_index :markets, [:source_id, :target_id], unique: true
  end
end
