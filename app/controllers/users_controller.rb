class UsersController < ApplicationController
  # Garante que apenas administradores acessem a gestão de funcionários
  before_action :check_admin

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    # GERA UM E-MAIL TÉCNICO AUTOMÁTICO
    # Isso resolve o conflito com o Devise sem exigir e-mail do vendedor
    if @user.username.present?
      @user.email = "#{@user.username.to_s.parameterize}@terminal.local"
    end

    if @user.save
      redirect_to users_path, notice: "Vendedor cadastrado com sucesso!"
    else
      # Caso falte algum campo ou a senha seja curta, ele mostra os erros na tela
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])

    # Proteção para o Admin não deletar a própria conta por acidente
    if @user == current_user
      redirect_to users_path, alert: "Você não pode excluir a sua própria conta de administrador!"
    else
      @user.destroy
      redirect_to users_path, notice: "Vendedor removido com sucesso!"
    end
  end

  private

  # Lista de campos permitidos vindo do formulário
  def user_params
    params.require(:user).permit(:name, :username, :password, :password_confirmation, :role)
  end

  # Filtro de segurança: se não for admin, volta para o início
  def check_admin
    unless current_user.admin?
      redirect_to root_path, alert: "Acesso restrito ao Administrador!"
    end
  end
end
