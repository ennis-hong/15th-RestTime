Rails.application.routes.draw do
  scope '(:lang)', locale: /en|tw/ do
    resources :products
    resources :shops

    root 'products#index'

    get '/about', to: 'pages#about'
    get '/choose_us', to: 'pages#choose_us'
    get '/join_us', to: 'pages#join_us'
    get '/contact_us', to: 'pages#contact_us'
    get '/terms', to:'pages#terms'
    get '/privacy', to:'pages#privacy'
    get '/refund_policy', to:'pages#refund_policy'
    devise_for :users, controllers: { sessions: 'users/sessions' }
  end
end
