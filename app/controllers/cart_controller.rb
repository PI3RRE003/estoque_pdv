class CartController < ApplicationController
  def add
    if params[:client_id].present?
      session[:selected_client_id] = params[:client_id]
    end

    query = params[:barcode_or_name]

    qty_to_add = params[:quantity].present? ? params[:quantity].to_i : 1

    product = Product.find_by(id: query) || Product.find_by(barcode: query)

    if product.nil? && query.present?
      product = Product.where("UPPER(name) LIKE ?", "%#{query.upcase}%").first
    end

    if product
      session[:cart] ||= {}
      id = product.id.to_s
      current_qty = session[:cart][id] || 0
      total_requested = current_qty + qty_to_add

      if total_requested > product.stock_quantity
        flash[:alert] = "Estoque insuficiente! #{product.name} tem apenas #{product.stock_quantity} un."
      elsif total_requested <= 0
        session[:cart].delete(id)
      else
        session[:cart][id] = total_requested
        flash[:notice] = "Adicionado: #{product.name}" if current_qty == 0
      end
    else
      flash[:alert] = "Produto '#{query}' não encontrado!"
    end

    redirect_to new_sale_path
  end

  def remove
    id = params[:id].to_s
    if session[:cart] && session[:cart][id]
      session[:cart].delete(id)
      flash[:notice] = "Item removido por completo."
    end
    redirect_to new_sale_path
  end
end
