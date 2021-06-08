source 'https://rubygems.org'
git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

ruby '2.7.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.3', '>= 6.1.3.1'

# Use postgresql as database
gem 'pg'

# Use Redis adapter to run Action Cable and sidekiq in production
gem 'redis', '~> 4.0'
gem 'sidekiq', '~> 6.2'

# Use Puma as the app server
gem 'puma', '~> 5.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'

# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

gem 'devise', '~> 4.8'
gem 'devise_token_auth', '~> 1.1'
gem 'graphql', '~> 1.12'
gem 'graphql_devise', '~> 0.16.0'
gem 'graphql_playground-rails'
gem 'cancancan', '~> 3.2'


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 5.0'
  gem 'dotenv-rails', '~> 2.7'
end

group :development do
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

