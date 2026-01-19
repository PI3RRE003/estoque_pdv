class ChangeBarcodeToOptionalInProducts < ActiveRecord::Migration[8.1]
  def change
    change_column_null :products, :barcode, true
  end
end
