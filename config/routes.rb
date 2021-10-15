require 'sidekiq/web'
require 'api_constraints'

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, :controllers => {
    :omniauth_callbacks => "omniauth_callbacks",
    :registrations => 'users/registrations',
  }
  devise_for :admin_users, ActiveAdmin::Devise.config
  begin
    ActiveAdmin.routes(self)
  rescue StandardError => e
    puts "ActiveAdmin: #{e.class}: #{e}"
  end

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
    mount GraphqlPlayground::Rails::Engine, at: "/graphql_playground", graphql_path: "/graphql"
  end

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['SIDEKIQ_USERNAME'] &&
    password == ENV['SIDEKIQ_PASSWORD']
  end

  mount Sidekiq::Web => "/sidekiq" # mount Sidekiq::Web in your Rails app
end