class DashboardController < ApplicationController
  def index
    # 1. Definir o intervalo de datas (Filtro ou Hoje)
    @start_date = params[:start_date].present? ? params[:start_date].to_date.beginning_of_day : Time.zone.now.beginning_of_day
    @end_date = params[:end_date].present? ? params[:end_date].to_date.end_of_day : Time.zone.now.end_of_day
    @range = @start_date..@end_date

    # 2. Vendas no período selecionado
    @sales_selected = Sale.where(created_at: @range)
    @revenue_today = @sales_selected.sum(:total)
    @sales_count = @sales_selected.count

    # 3. Lucro no período (Ajustado para 'price_cost' que é o seu campo oficial)
    @profit_today = SaleItem.joins(:sale, :product)
                            .where(sales: { created_at: @range })
                            .sum("sale_items.quantity * (sale_items.price - products.price_cost)") rescue 0

    # 4. Meios de pagamento no período
    @sales_by_payment = @sales_selected.group(:payment_method).count

    # 5. Dados para o Gráfico (Lógica nativa para evitar dependência de gems extras)
    @sales_by_day = @sales_selected.group("DATE(sales.created_at)").sum(:total)

    # 6. Estoque baixo (Ajustado para o seu campo oficial: 'stock_quantity')
    @low_stock_products = Product.where("stock_quantity < ?", 10).order(:stock_quantity).limit(10)

    # 7. Ranking de Vendedores
    @top_sellers = User.joins(:sales)
                       .where(sales: { created_at: @range })
                       .group("users.id", "users.name") # Adicionado users.name para compatibilidade com SQL
                       .select("users.name, sum(sales.total) as total_sold")
                       .order("total_sold DESC")
  end

  def fechamento
    @date = params[:date].present? ? params[:date].to_date : Time.zone.now.to_date
    @range = @date.beginning_of_day..@date.end_of_day

    @sales_today = Sale.where(created_at: @range)
    @total_revenue = @sales_today.sum(:total)

    @products_sold = SaleItem.where(sale_id: @sales_today.pluck(:id))
                             .joins(:product)
                             .group("products.name")
                             .sum(:quantity)

    render layout: false
  end
end
