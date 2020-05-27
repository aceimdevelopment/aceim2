Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
	scope module: :admin do
		resources :dashboard, only: [:index]
	end

	namespace :api do
		namespace :v1 do
			resources :items, only: [:index, :create, :destroy, :update]
		end
	end

	resources :student_session, only: [:index]
	root to: 'home#index'
end
