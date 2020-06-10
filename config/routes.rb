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
