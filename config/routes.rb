Rails.application.routes.draw do

  # Authentication with social providers.
  get "auth/use/:provider" => "oauths#use_provider", as: "use_provider"
  get "/auth/:provider/callback" => "oauths#create"
  delete "/auth/:provider" => "oauths#destroy", as: "auth"
  get "/auth/failure" => "oauths#failure"

  namespace :m3_table_admin, path: "admin" do
    get "/", to: "users#index"
    get "/autocomplete", to: "application#autocomplete"

    resources :pages
    resources :users
    resources :images
    resources :projects
  end

  get '/pages/*slug' => 'pages#show', :as => 'page'

  resources :users
  resources :sessions, only: [:new, :create, :destroy] #we limit to just those actions, because we dont need other actions
  match '/signup',  to: 'users#new', via: 'get'
  match '/login',  to: 'sessions#new', via: 'get'
  match '/logout', to: 'sessions#destroy', via: 'delete'

  root to: "users#new", as: :root
  match "/", to: "sessions#new", via: 'get'

  namespace :api do
    namespace :v1 do
      post "login", :to => "sessions#create"
      post "register", :to => "users#create"
      post "update_user", :to => "users#update"
      post "user", :to => "users#show"

      resources :oauths, only: [ :create ]

      resources :help_requests;
      resources :help_request_rescuers;
    end
  end

  get 'setup/step_2', to: 'setup#step_2'
  get 'setup/finished', to: 'setup#finished'

  # User email verifications.
  resources :email_verifications, only: [:create, :update] do
    member do
      get :pending
      get :update
    end
  end

end
