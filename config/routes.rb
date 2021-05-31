Rails.application.routes.draw do
  mount_graphql_devise_for 'User', at: 'graphql_auth'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  if Rails.env.development?
    mount GraphQL::Playground::Engine, at: "/graphql_playground", graphql_path: "/graphql"
  end
end
