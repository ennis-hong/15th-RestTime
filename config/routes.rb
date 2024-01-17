Rails.application.routes.draw do
  get 'vendor/index'
  # Constraints for Avo Engine
  authenticate :user, -> user { user.admin? } do
    mount Avo::Engine => '/avo'
  end

  # Devise routes
  devise_for :users, only: :omniauth_callbacks, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  # Global scope with locale parameter
  scope '(:lang)', locale: /en|tw/ do

    root 'pages#index'

    devise_for :users, skip: :omniauth_callbacks, controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
    }

    resources :products do
      collection do
        get :my
        delete :my
      end
    end

    resources :shops do
      resources :comments, shallow: true, only: [:create, :destroy]
    end

    resource :service_times, only: %i[edit update]

    # API namespace
    namespace :api do
      namespace :v1 do
        resources :shops, only: [] do
          member do
            patch :like
          end
        end

        resources :bookings, only: [] do
          member do
            patch :available_slots
          end
        end
      end
    end

    resource :booking, only: %i[show create destroy] do
      collection do
        get :checkout
      end
    end

    resources :orders, only: %i[index show new create edit update] do
      collection do
        post :payment_result
      end
      member do
        patch :cancel
      end
    end

    resources :vendor

    namespace :vendor do
      resources :orders,only: %i[show] do
        collection do
          get :my
        end
        member do
          get :confirm_redeem
          patch :redeem
        end
      end
    end

    # Static pages
    %w(about privacy refund_policy payment).each do |page|
      get "/#{page}", to: "pages##{page}"
    end

    # Search route
    get "/search", to: "shops#search"

    # Home page
    get "/index", to: "pages#index"

  end
end
