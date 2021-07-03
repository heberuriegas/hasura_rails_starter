require 'sidekiq/web'

Rails.application.routes.draw do
  mount_graphql_devise_for 'User', at: 'graphql_auth',  operations: {
    login:    Mutations::Login,
    register:  Mutations::Register
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/auth/user', to: 'auth#user'
  get '/auth/refresh_token', to: 'auth#refresh_token'
  
  get '/hasura/auth', to: 'auth#hasura'
  post '/hasura/auth', to: 'auth#hasura'
  mount HasuraHandler::Engine => '/hasura'

  if Rails.env.development?
    mount GraphqlPlayground::Rails::Engine, at: "/graphql_playground", graphql_path: "/graphql_auth"
    mount Sidekiq::Web => "/sidekiq" # mount Sidekiq::Web in your Rails app
  end
end
