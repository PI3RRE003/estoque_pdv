class CreateClients < ActiveRecord::Migration[8.1]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :cpf
      t.string :phone
      t.string :zipcode
      t.string :address
      t.string :neighborhood
      t.string :city
      t.string :state

      t.timestamps
    end
  end
end
