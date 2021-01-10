Rails.application.routes.draw do
  resources :billboards
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: { registrations: "registrations" }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # resources :partial_qualifications

  resources :partial_qualifications
  resources :home, only: [:index] do
    collection do
      get 'select_role'
      get 'longged_in'
    end
  end

  resources :payment_details do
    member do
      get 'confirm'
      get 'read_report'
      get 'generate_pdf'
    end

  end

  resources :careers, only: [:index] do
    member do
      get 'constance'
      get 'constance_verify'
      get 'career_finished_certificate'
      get 'career_finished_certificate_verify'
    end
  end

  resources :academic_records, only: [:index, :show] do
    member do
      get 'send_confirmation_mail'
      get 'show_payments_accounts'
      get 'certificate'
    end
  end

  resources :sections, only: [:index] do
    member do
      get 'split'
      get 'enrollments_to_canvas'
      get 'create_on_canvas'
    end
  end

  resources :qualification_schemas, only: [:index] do
    member do
      get 'onoff_switch'
    end
  end

  resources :periods, only: [:index] do
    member do
      get :unreported
      get 'onoff_switch'
      get 'clean_not_reported'
    end
  end

  scope module: :admin do
    resources :dashboard, only: [:index]
  end

  namespace :api do
    namespace :v1 do
      resources :items, only: [:index, :create, :destroy, :update] do 
        collection do
          get 'open_newers_registration'
        end
      end
    end
  end

  resources :student_session, only: [:index] do
    collection do
      get 'multimedia'
    end
  end
  resources :instructor_session, only: [:index] do
    member do
      get 'show_sections'
    end
  end
  resources :enrollment, only: [:index] do
    member do
      get 'regular'
      get 'import_aceim_old'
      get 'sync_up_width_canvas'
    end
  end




  resources :users, only: [:update] do
    member do
      post 'update_canvas_email'
      get 'registration_canvas'
    end
  end

  
  root to: 'home#index'
end
