json.extract! client, :id, :name, :cpf, :phone, :zipcode, :address, :neighborhood, :city, :state, :created_at, :updated_at
json.url client_url(client, format: :json)
