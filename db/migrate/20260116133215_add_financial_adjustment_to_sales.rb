class AddFinancialAdjustmentToSales < ActiveRecord::Migration[8.1]
  def change
    add_column :sales, :discount, :decimal
    add_column :sales, :surcharge, :decimal
  end
end
