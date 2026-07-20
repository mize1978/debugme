Rails.application.routes.draw do
  root "error_logs#new"

  resources :error_logs, only: [:new, :create, :show] do
    member do
      get :stream
    end
  end

  get "ranking", to: "error_logs#ranking", as: :ranking

  get "up" => "rails/health#show", as: :rails_health_check
end
