Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: { registrations: "registrations" }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html


  resources :home, only: [:index] do
    collection do
      get 'select_role'
      get 'longged_in'
    end
  end

  resources :payment_details do
    member do
      get 'confirm'
    end

  end

  resources :academic_records, only: [:index] do
    member do
      get 'send_confirmation_mail'
      get 'show_payments_accounts'
    end
  end

  resources :sections, only: [:index] do
    member do
      get 'split'
    end
  end

  resources :periods, only: [:index] do
    member do
      get 'onoff_switch'
    end
  end

  scope module: :admin do
    resources :dashboard, only: [:index]
  end

  namespace :api do
    namespace :v1 do
      resources :items, only: [:index, :create, :destroy, :update]
    end
  end

  resources :student_session, only: [:index]
  resources :enrollment, only: [:index] do
    member do
      get 'regular'
    end
  end

  resources :users, only: [:update]
  
  root to: 'home#index'
end
