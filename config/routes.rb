Rails.application.routes.draw do
  resources :products

  root 'products#index'
  resource :users, except: [:destroy] do
    collection do
      get :sign_in
    end
  end

  resource :sessions, only: [:create, :destroy]

end
