class AddPriceCostToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :price_cost, :decimal
  end
end
