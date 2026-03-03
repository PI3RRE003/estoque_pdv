class DashboardController < ApplicationController
  def index
    # 1. Definir o intervalo de datas (Filtro ou Hoje)
    @start_date = params[:start_date].present? ? params[:start_date].to_date.beginning_of_day : Time.zone.now.beginning_of_day
    @end_date = params[:end_date].present? ? params[:end_date].to_date.end_of_day : Time.zone.now.end_of_day
    @range = @start_date..@end_date

    # 2. Vendas no período (FATURAMENTO REAL = Total - Descontos)
    @sales_selected = Sale.where(created_at: @range)
    @sales_count = @sales_selected.count

    # AJUSTE: Subtrai o desconto do faturamento bruto
    @revenue_today = @sales_selected.sum(:total).to_f - @sales_selected.sum(:discount).to_f

    # 3. LUCRO REAL (Preço de Venda - Preço de Custo - Descontos)
    # Calculamos o lucro bruto dos itens e subtraímos os descontos totais aplicados nas vendas
    profit_from_items = SaleItem.joins(:sale, :product)
                                .where(sales: { created_at: @range })
                                .sum("sale_items.quantity * (sale_items.price - products.price_cost)").to_f

    total_discounts = @sales_selected.sum(:discount).to_f
    @profit_today = profit_from_items - total_discounts

    # 4. Meios de pagamento
    @sales_by_payment = @sales_selected.group(:payment_method).count

    # 5. Dados para o Gráfico (Ajustado para faturamento líquido)
    # Aqui fazemos uma soma que já considera o desconto por dia
    @sales_by_day = @sales_selected.group("DATE(sales.created_at)")
                                   .sum("sales.total - sales.discount")

    # 6. Estoque baixo
    @low_stock_products = Product.where("stock_quantity < ?", 10).order(:stock_quantity).limit(10)

    # 7. Ranking de Vendedores (Ajustado para faturamento líquido)
    @top_sellers = User.joins(:sales)
                       .where(sales: { created_at: @range })
                       .group("users.id", "users.name")
                       .select("users.name, sum(sales.total - sales.discount) as total_sold")
                       .order("total_sold DESC")
  end

  def fechamento
    @date = params[:date].present? ? params[:date].to_date : Time.zone.now.to_date
    @range = @date.beginning_of_day..@date.end_of_day

    @sales_today = Sale.where(created_at: @range)
    # Ajuste no fechamento para faturamento líquido
    @total_revenue = @sales_today.sum(:total).to_f - @sales_today.sum(:discount).to_f

    @products_sold = SaleItem.where(sale_id: @sales_today.pluck(:id))
                             .joins(:product)
                             .group("products.name")
                             .sum(:quantity)

    render layout: false
  end
end
