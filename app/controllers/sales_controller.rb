class SalesController < ApplicationController
  # 1. Carrega a tela do PDV
  def new
    @sale = Sale.new
    @products = Product.where(active: true).order(:name)
    @clients = Client.order(:name)
  end

  # Lista de vendas com filtros
  def index
    # O includes evita que o nome do cliente suma na lista
    @sales = Sale.includes(:client, :sale_items, :user).all

    # Filtro por ID da Venda
    if params[:query].present?
      @sales = @sales.where(id: params[:query])
    end

    # Filtro por Data de Início - Usando sales.created_at para evitar erro de ambiguidade
    if params[:start_date].present?
      @sales = @sales.where("sales.created_at >= ?", params[:start_date].to_date.beginning_of_day)
    end

    # Filtro por Data de Fim
    if params[:end_date].present?
      @sales = @sales.where("sales.created_at <= ?", params[:end_date].to_date.end_of_day)
    end

    @sales = @sales.order("sales.created_at DESC")
  end

  # Processamento da Venda
  def create
    @sale = Sale.new(sale_params)
    @sale.user = current_user

    # Se o cliente foi selecionado via AJAX/Sessão e não veio no params, garantimos ele aqui
    @sale.client_id ||= session[:selected_client_id]

    if session[:cart].present? && session[:cart].any?
      ActiveRecord::Base.transaction do
        @sale.save!

        session[:cart].each do |product_id, quantity|
          product = Product.find(product_id)

          unless product.active?
            raise "O produto #{product.name} não está mais disponível."
          end

          @sale.sale_items.create!(
            product: product,
            quantity: quantity,
            price: product.price
          )

          # Baixa de estoque
          product.update!(stock_quantity: product.stock_quantity - quantity.to_i)
        end
      end

      # LIMPEZA PÓS-VENDA
      session[:cart] = {}
      session[:selected_client_id] = nil

      # Redireciona para o Cupom Térmico
      redirect_to receipt_sale_path(@sale), notice: "Venda finalizada com sucesso!"
    else
      redirect_to new_sale_path, alert: "O carrinho está vazio!"
    end

  rescue ActiveRecord::RecordInvalid => e
    redirect_to new_sale_path, alert: "Erro na validação: #{e.message}"
  rescue => e
    redirect_to new_sale_path, alert: "Erro: #{e.message}"
  end

  def show
    @sale = Sale.includes(:client, :user, sale_items: :product).find(params[:id])
  end

  def receipt
    @sale = Sale.includes(:client, :user, sale_items: :product).find(params[:id])
    render layout: false
  end

  # API para busca de cliente via CPF
  def find_client
    client = Client.find_by(cpf: params[:cpf])
    render json: { name: client&.name, id: client&.id }
  end

  private

  def sale_params
    # Permitimos os campos necessários para a venda
    params.permit(:total, :payment_method, :client_id, :discount, :surcharge)
  end
end
