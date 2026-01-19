class User < ApplicationRecord
  # Removemos o :validatable para o Devise parar de exigir e-mail
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  # Níveis de acesso
  enum :role, { vendedor: "vendedor", admin: "admin" }, default: "vendedor"
  has_many :sales

  # Validações manuais (substituindo o :validatable)
  validates :name, presence: true
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  # Valida a senha apenas se ela estiver sendo alterada ou for um usuário novo
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  validates :password, confirmation: true, if: :password_required?

  # MÉTODO VITAL: Faz o login funcionar buscando pelo username
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:username))
      where(conditions.to_h).where([ "lower(username) = :value", { value: login.downcase } ]).first
    elsif conditions.has_key?(:username)
      where(conditions.to_h).first
    end
  end

  # --- MÉTODOS PARA DESATIVAR O E-MAIL ---

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end

  private

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end
