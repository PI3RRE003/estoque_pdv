Rails.application.routes.draw do
  # Usamos 'vendedores' no path para o Devise não interferir
  resources :users, path: "vendedores", only: [ :index, :new, :create, :destroy ]
  devise_for :users

  # Página inicial
  root "dashboard#index"

  # Rotas de Dashboard e Fechamento
  get "dashboard/index"
  get "fechamento", to: "dashboard#fechamento"

  # Rotas de Clientes
  resources :clients

  # Rotas de Produtos (CORRIGIDO: reativar agora está dentro do bloco)
  resources :products do
    patch :reativar, on: :member
  end

  resources :sales do
    member do
      get :receipt # Rota para o cupom
    end
  end

  # Rotas de Vendas e Busca de Cliente
  get "find_client", to: "sales#find_client"
  resources :sales, only: [ :index, :new, :create, :show ]

  # Rotas do Carrinho (PDV)
  post "cart/add", to: "cart#add", as: "cart_add"
  delete "cart/remove/:id", to: "cart#remove", as: "cart_remove"

  # Rotas de Gestão de Usuários (Vendedores)
  resources :users, only: [ :index, :new, :create, :destroy ]
end
