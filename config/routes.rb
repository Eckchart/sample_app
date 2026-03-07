Rails.application.routes.draw do
  # Defines the root path route ("/")
  root   "static_pages#home"

  get    "/signup", to: "users#new"

  # Due to Turbo, when we submit an invalid micropost
  # on the root (home) page, we won't actually see
  # the `/microposts` URL in our URL bar, but I'll
  # leave this anyway, so that "GET /microposts"
  # redirects to "static_pages#home" or "/" (since
  # "home" is the root of the application), just in case.
  get    "/microposts", to: "static_pages#home"
  get    "/help",       to: "static_pages#help"
  get    "/about",      to: "static_pages#about"
  get    "/contact",    to: "static_pages#contact"

  get    "/login",  to: "sessions#new"
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :users
  resources :microposts, only: [:create, :destroy]
end
