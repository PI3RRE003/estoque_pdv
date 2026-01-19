class AddCostPriceToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :cost_price, :decimal
  end
end
