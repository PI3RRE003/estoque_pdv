class SaleItem < ApplicationRecord
  belongs_to :sale
  belongs_to :product

  def total_price
    quantity * price
  end
end
