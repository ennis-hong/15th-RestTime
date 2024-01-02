Rails.application.routes.draw do
  get 'vendor/index'
  # Constraints for Avo Engine
  authenticate :user, -> user { user.admin? } do
    mount Avo::Engine => '/avo'
  end

  devise_for :users, only: :omniauth_callbacks, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  # Global scope with locale parameter
  scope '(:lang)', locale: /en|tw/ do
    root 'products#index'

    resources :vendor

    # Devise routes
    devise_for :users, skip: :omniauth_callbacks, controllers: { sessions: 'users/sessions' }
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
      end
    end

    resource :booking, only: %i[show create destroy] do
      collection do
        get :checkout
      end
    end

    resources :orders, only: %i[show] do
      collection do
        get :my_bookings
        post :payment_result
      end
    end

    namespace :admin do
      resources :orders, only: %i[index show create] do
        member do
          get :confirm_redeem
          patch :redeem
        end
      end
    end

    # Static pages
    %w(about choose_us join_us contact_us terms privacy refund_policy payment order_question refund).each do |page|
      get "/#{page}", to: "pages##{page}"
    end

    # Search route
    get "/search", to: "products#search"

    # Home page
    get "/index", to: "pages#index"

  end
end
