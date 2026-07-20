Rails.application.routes.draw do
  root "debug_logs#new"

  resources :debug_logs, only: [:new, :create, :show] do
    member do
      get :stream
    end
  end

  get "ranking", to: "debug_logs#ranking", as: :ranking

  get "up" => "rails/health#show", as: :rails_health_check
end
