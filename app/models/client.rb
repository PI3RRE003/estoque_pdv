class Client < ApplicationRecord
  # Esta linha permite que o Rails entenda o comando @client.sales
  has_many :sales, dependent: :nullify

  validates :name, presence: true
  validates :phone, presence: true, format: {
    with: /\A\d{10,11}\z/,
    message: "deve conter DDD e número (10 ou 11 dígitos)"
  }
  validates :cpf, presence: true, uniqueness: true, cpf: true

  before_validation :clear_cpf

  private

  def clear_cpf
    self.cpf = cpf.to_s.gsub(/[^\d]/, "") if cpf.present?
  end
end
