class Sale < ApplicationRecord
  belongs_to :user
  belongs_to :client, optional: true
  has_many :sale_items, dependent: :destroy
  has_many :products, through: :sale_items

  accepts_nested_attributes_for :sale_items
  after_create :subtrair_estoque

  PAYMENT_METHODS = [ "Dinheiro", "Cartão de Crédito", "Cartão de Débito", "Pix" ].freeze

  validates :payment_method, presence: true, inclusion: { in: PAYMENT_METHODS }

  private

  def subtrair_estoque
    sale_items.each do |item|
      # O método decrement! altera o valor no banco e salva na hora
      item.product.decrement!(:stock_quantity, item.quantity)
    end
  end
end
