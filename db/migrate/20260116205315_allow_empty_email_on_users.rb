class AllowEmptyEmailOnUsers < ActiveRecord::Migration[7.1]
  def change
    # Permite que o e-mail seja nulo ou vazio
    change_column_null :users, :email, true
  end
end
