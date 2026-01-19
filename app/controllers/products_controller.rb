class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products
  def index
    # Lógica de alternância: Se o parâmetro 'show_inactive' for true, mostra os inativos
    if params[:status] == "inativo"
      @products = Product.where(active: false)
    else
      @products = Product.where(active: true)
    end

    # Filtro de busca (Busca por código de barras ou nome)
    if params[:query].present?
      query = params[:query].downcase
      @products = @products.where(
        "barcode = ? OR lower(name) LIKE ?",
        params[:query],
        "%#{query}%"
      )
    end

    @products = @products.order(:name)
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to products_path, notice: "Produto criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      redirect_to products_path, notice: "Produto atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product = Product.find(params[:id])
    # update_column ignora validações e callbacks, força a gravação no banco
    if @product.update_column(:active, false)
      redirect_to products_path, notice: "Produto inativado com sucesso."
    else
      redirect_to products_path, alert: "Erro ao inativar."
    end
  end

  # Adicione este método no ProductsController
  def reativar
    @product = Product.find(params[:id])
    # update_attribute(nome, valor) pula as validações
    if @product.update_attribute(:active, true)
      redirect_to products_path, notice: "Produto reativado com sucesso!"
    else
      redirect_to products_path(status: "inativo"), alert: "Erro ao reativar."
    end
  end


  private

  def set_product
    # Usando params[:id] que é o padrão mais estável
    @product = Product.find(params[:id])
  end

  def product_params
    # Ajustado para incluir 'price_cost' e 'stock_quantity' conforme seu banco
    params.require(:product).permit(:name, :price, :price_cost, :stock_quantity, :barcode, :active)
  end
end
