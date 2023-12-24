Rails.application.routes.draw do
  constraints ->(request) { request.env["restime"]&.user&.vendor? } do
    mount Avo::Engine, at: Avo.configuration.root_path
  end

  scope '(:lang)', locale: /en|tw/ do
    root 'products#index'

    resources :products do
      collection do
        get :my
      end
    end

    resources :shops
    resource :service_times, only: %i[edit update]


    namespace :api do
      namespace :v1 do
        resources :shops, only: [] do
          member do
            patch :like
          end
        end
      end
    end

    get '/about', to: 'pages#about'
    get '/choose_us', to: 'pages#choose_us'
    get '/join_us', to: 'pages#join_us'
    get '/contact_us', to: 'pages#contact_us'
    get '/terms', to: 'pages#terms'
    get '/privacy', to: 'pages#privacy'
    get '/refund_policy', to: 'pages#refund_policy'
    get '/payment', to: 'pages#payment'
    get '/order', to: 'pages#order'
    get '/refund', to: 'pages#refund'

    get "/search", to: "products#search"


    devise_for :users, controllers: { sessions: 'users/sessions' }
  end
end
