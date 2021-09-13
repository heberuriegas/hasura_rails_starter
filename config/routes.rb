require 'sidekiq/web'
require 'api_constraints'

Rails.application.routes.draw do
  begin
    ActiveAdmin.routes(self)
  rescue Exception => e
    puts "ActiveAdmin: #{e.class}: #{e}"
  end
  devise_for :users, ActiveAdmin::Devise.config

  mount_graphql_devise_for 'User', at: 'graphql_auth',  operations: {
    login:    Mutations::Login,
    register:  Mutations::Register,
  }
  post "/graphql", to: "graphql#execute"

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      get '/auth/user', to: 'auth#user'
      get '/auth/refresh_token', to: 'auth#refresh_token'
      
      get '/hasura/auth', to: 'auth#hasura'
      post '/hasura/auth', to: 'auth#hasura'
      mount HasuraHandler::Engine => '/hasura'
    end
  end

  if Rails.env.development?
    mount GraphqlPlayground::Rails::Engine, at: "/graphql_playground", graphql_path: "/graphql_auth"
  end

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['SIDEKIQ_USERNAME'] &&
    password == ENV['SIDEKIQ_PASSWORD']
  end

  mount Sidekiq::Web => "/sidekiq" # mount Sidekiq::Web in your Rails app
end