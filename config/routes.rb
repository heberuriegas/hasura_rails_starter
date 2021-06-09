Rails.application.routes.draw do
  mount_graphql_devise_for 'User', at: 'graphql_auth',  operations: {
    login:    Mutations::Login,
    register:  Mutations::Register,
    # register: Mutations::Register
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/hasura/auth', to: 'hasura#auth'
  post '/hasura/auth', to: 'hasura#auth'

  if Rails.env.development?
    mount GraphqlPlayground::Rails::Engine, at: "/graphql_playground", graphql_path: "/graphql_auth"
  end
end
