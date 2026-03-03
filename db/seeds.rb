puts "🧹 Limpando banco de dados antigo..."
SaleItem.destroy_all
Sale.destroy_all
Product.destroy_all
Client.destroy_all
User.destroy_all

puts "👤 Criando usuário administrador..."
User.create!(
  name: "Admin",
  username: "admin",
  password: "123456",
  password_confirmation: "123456",
  role: "admin"
)

puts "📦 Criando produtos de exemplo..."
Product.create!([
  {
    name: "Whey Protein Isolado 900g",
    price: 159.90,
    price_cost: 110.00, # Adicionado campo obrigatório
    stock_quantity: 20,
    active: true
  },
  {
    name: "Creatina Monohidratada 300g",
    price: 89.90,
    price_cost: 45.00, # Adicionado campo obrigatório
    stock_quantity: 15,
    active: true
  },
  {
    name: "Pré-Treino Explosion 300g",
    price: 110.00,
    price_cost: 60.00, # Adicionado campo obrigatório
    stock_quantity: 5,
    active: true
  }
])

puts "✅ Seed finalizado com sucesso!"
