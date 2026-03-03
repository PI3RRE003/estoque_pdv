class User < ApplicationRecord
  # Removemos o :validatable para o Devise parar de exigir e-mail
  # Mantemos os módulos essenciais para o login por username
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  # Níveis de acesso (Enum com mapeamento explícito)
  enum :role, { vendedor: "vendedor", admin: "admin" }, default: "vendedor"

  has_many :sales

  # Validações manuais (Substituindo o comportamento do :validatable)
  validates :name, presence: true
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  # Validação de Senha: Mínimo de 6 caracteres
  # Só valida se for um novo registro ou se o campo de senha não estiver vazio
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  validates :password, confirmation: true, if: :password_required?

  # MÉTODO VITAL: Faz o login funcionar buscando pelo username (case insensitive)
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:username))
      where(conditions.to_h).where([ "lower(username) = :value", { value: login.downcase } ]).first
    elsif conditions.has_key?(:username)
      where(conditions.to_h).first
    end
  end

  # --- MÉTODOS PARA DESATIVAR A EXIGÊNCIA DE E-MAIL NO DEVISE ---

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

  # Define quando a senha é obrigatória (Criação ou Alteração)
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end
