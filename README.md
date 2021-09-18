# Hasura Rails Starter [WIP]

Hasura Rails Starter simplifies the setup of Hasura and a rails web server that handle action endpoints, authentication, authorization, image handling and jobs using docker containers.

## What it contains?

- Rails 6.1 as web server
- PostgreSQL 12 as database
- Hasura 2.0 as graphql engine
- Sidekiq as job manager
- User authentication with JWT using devise and devise-jwt

## Getting started

1. Clone the repo

```
git clone https://github.com/woohoou/hasura_rails_starter
```

2. Copy and configure the env file

```
cp env.sample .env
```

3. Build containers

```
docker-compose up
```

4. Run migrations and seeds

```
docker-compose exec backend rails db:setup
```

5. Apply hasura metadata export

```
hasura metadata apply --project hasura
```

Hasura should be running in port 8080 and the rails web server port 3000

## Features

- Graphql sign up & sign in
- Auth webhook for jwt authentication hasura endpoints
- Actions and events microservices
- OTP authentication for smartphones
- Configure image uploads with active storage
- Configure remote graphql schema

## Deploy to heroku

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/woohoou/hasura_rails_starter)

## TODO

- OAuth integration
- Configure one click heroku deploy
- Docs for registration and authentication with email and otp
- Docs for actions and events microservices for hasura
- Docs for file uploads

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
