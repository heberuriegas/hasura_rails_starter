# Hasura Rails Starter [WIP]

Hasura Rails Starter simplifies the setup of Hasura and a rails web server that handle action endpoints, authentication, authorization, image handling and jobs using docker containers.

## What it contains?

- Rails 6.1 and PostgreSQL 12 as webserver and database
- Hasura 2.0 as graphql engine
- User authentication
  - username/email with doorkeeper
  - otp sms with active_model_otp
  - client OAuth with doorkeeper assertion strategy
  - server OAuth with omniauth
- Authorization with cancancan
- File uploads with ActiveStorage
- Sidekiq as job manager

## Getting started

1. Clone the repo

```
git clone https://github.com/woohoou/hasura_rails_starter
```

2. Copy and configure the env file

```
cp .env.sample .env
```

3. Install node packages

```
yarn
```

4. Build containers

```
docker-compose up
```

5. Run migrations and seeds

```
docker-compose exec backend rails db:setup
```


6. Apply hasura metadata export

```
hasura metadata apply --project hasura
```

Hasura should be running in port 8080 and the rails web server port 3000

## Features

- Authentication with email, phone number (with otp) and third party oauth with doorkeeper
- Actions and events microservices
- Configure image uploads with active storage
- Configure remote graphql schema
- OAuth integration with omniauth
- Authorization with cancancan

## Deploy to heroku

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/woohoou/hasura_rails_starter)

## TODO

- Configure one click heroku deploy
- Docs for authorization with cancancan
- Docs for registration and authentication with email and otp with devise and doorkeeper
- Docs for OAuth assertion strategy with github and octokit example
- Docs for OAuth with omniauth
- Docs for remote graphql schema with graphql-ruby
- Docs for hasura authentication
- Docs for actions and events microservices for hasura with hasura_handler
- Docs for file uploads with ActiveStorage
- Reference to ready to go react native application with kitten tricks

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
