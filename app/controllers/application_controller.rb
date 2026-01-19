class ApplicationController < ActionController::Base
  # Exige login para entrar em qualquer página
  before_action :authenticate_user!

  # Permite que o Rails aceite campos extras no Devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Adicionamos :username aqui para permitir o cadastro
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :role, :username ])

    # Adicionamos :username aqui para permitir o LOGIN
    devise_parameter_sanitizer.permit(:sign_in, keys: [ :username ])

    # Adicionamos :username aqui para permitir a edição do perfil
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :role, :username ])
  end
end
