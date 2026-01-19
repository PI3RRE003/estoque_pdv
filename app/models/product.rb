class Product < ApplicationRecord
  has_many :sale_items

  # Ajustado para :price_cost (nome real no seu banco)
  validates :name, :price, :stock_quantity, :price_cost, presence: true

  # Agora o barcode é validado apenas se for preenchido (impede duplicados)
  validates :barcode, uniqueness: true, allow_blank: true

  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :price_cost, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Garante que o banco salve NULL em vez de string vazia ""
  # Isso evita que o banco ache que dois produtos sem código são "iguais"
  before_validation :normalize_barcode
  def price=(val)
    if val.is_a?(String)
      super(val.gsub(",", "."))
    else
      super(val)
    end
  end

  def price_cost=(val)
    if val.is_a?(String)
      super(val.gsub(",", "."))
    else
      super(val)
    end
  end

  private

  def normalize_barcode
    self.barcode = nil if barcode.blank?
  end
end
