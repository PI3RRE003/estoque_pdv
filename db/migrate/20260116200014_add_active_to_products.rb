class AddActiveToProducts < ActiveRecord::Migration[7.1]
  def change
    # Adicionamos o default: true para que todos os produtos atuais fiquem ativos
    add_column :products, :active, :boolean, default: true
  end
end
