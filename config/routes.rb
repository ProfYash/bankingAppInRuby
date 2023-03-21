Rails.application.routes.draw do
  resources :accounts do
    post "deposit", on: :member
    post "withdraw", on: :member
    post "transfer", on: :member
  end
  resources :banks
  devise_for :users, controllers: {
                       sessions: "users/sessions",
                       registrations: "users/registrations",
                     }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "accounts#index"
end
