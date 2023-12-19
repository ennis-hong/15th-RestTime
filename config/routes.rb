Rails.application.routes.draw do
  scope '(:lang)', locale: /en|tw/ do
    resources :products
    resources :shops

    root 'products#index'

    devise_for :users, controllers: { sessions: 'users/sessions' }
  end
end
