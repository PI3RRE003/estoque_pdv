class AddPriceToSaleItems < ActiveRecord::Migration[8.1]
  def change
    add_column :sale_items, :price, :decimal
  end
end
