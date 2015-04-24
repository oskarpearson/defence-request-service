Rails.application.routes.draw do
  root "dashboards#show"

  resource :dashboard, only: [:show]
  get "/refresh_dashboard", to: "dashboards#refresh_dashboard"

  resources :defence_requests, except: [:index] do
    member do
      post "resend_details"
      patch "solicitor_time_of_arrival" => "defence_requests#solicitor_time_of_arrival", as: "solicitor_time_of_arrival"
    end
  end

  resource :abort_defence_request, only: [:new, :create]
  resource :finish_defence_request, only: [:new, :create]
  resource :solicitor_search, only: [:create]
  resource :transition_defence_request, only: [:new, :create]

  get "/auth/:provider/callback", to: "sessions#create"
  get "/status" => "status#index"
  get "/help", controller: :static, action: :help, as: :help
  get "/maintenance", controller: :static, action: :maintenance, as: :maintenance
  get "/cookies", controller: :static, action: :cookies, as: :cookies
  get "/accessibility", controller: :static, action: :accessibility, as: :accessibility
  get "/terms", controller: :static, action: :terms, as: :terms
  get "/expired", controller: :static, action: :expired, as: :expired
end
