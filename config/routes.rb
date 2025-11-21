Rails.application.routes.draw do
  resources :teams, only: [:index, :new, :create, :show] do
    resources :retrospectives, only: [:new, :create]
    collection do
      post :add_participant_input
    end
  end
  resources :retrospectives, only: [:show] do
    member do
      post :change_ice_breaker_question
      post :advance_step
      post :reveal_ticket
      post :next_revealer
      get :revealer_section
    end
    resources :tickets, only: [:create, :update, :destroy] do
      post :reactions, to: "reactions#create"
    end
  end
  resources :users, only: [:create]
  get "signup", to: "users#new"
  get "home/index"
  resource :session
  get "login", to: "sessions#new"
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
