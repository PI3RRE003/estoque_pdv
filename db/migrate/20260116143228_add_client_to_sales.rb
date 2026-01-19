class AddClientToSales < ActiveRecord::Migration[7.1]
  def change
    # Adicionamos null: true para não travar nas vendas que já existem
    add_reference :sales, :client, null: true, foreign_key: true
  end
end
