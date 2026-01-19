class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :barcode
      t.decimal :price, precision: 8, scale: 2
      t.integer :stock_quantity

      t.timestamps
    end
  end
end
