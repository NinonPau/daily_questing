Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :user_moods, only: [:update, :create, :new, :edit]


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :tasks, only: [:index, :new, :create, :edit, :update] do
    member do
      patch :complete, :ignore, :unignore
    end
    collection do
      post :random
    end
  end
end
