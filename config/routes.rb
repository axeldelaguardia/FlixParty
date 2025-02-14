Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "welcome#index"

  get "/register", controller: "users", to: "users#new"
	get "/login", to: "users#login_form"
	post "/login", to: "users#login_user"
	get "/logout", to: "users#logout_user"

	resources :users, only: :create
	resource :user, only: :show, path: "/dashboard" do
		resources :discover, only: :index
    resources :movies, only: [:index, :show] do
			resources :parties, only: [:show, :new, :create]
		end
	end
end