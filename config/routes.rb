Rails.application.routes.draw do
  # Constraints for Avo Engine
  authenticate :user, -> user { user.admin? } do
    mount Avo::Engine => '/avo'
  end


  # Global scope with locale parameter
  scope '(:lang)', locale: /en|tw/ do
    root 'products#index'

    resources :products do
      collection do
        get :my
      end
    end

    resources :shops
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

    # Static pages
    %w(about choose_us join_us contact_us terms privacy refund_policy payment order refund).each do |page|
      get "/#{page}", to: "pages##{page}"
    end

    # Search route
    get "/search", to: "products#search"

    # Devise routes
    devise_for :users, controllers: { sessions: 'users/sessions' }
  end
end
