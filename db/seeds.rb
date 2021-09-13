# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create_with(
  name: ENV["ADMIN_NAME"] || Rails.application.credentials.admin[:name],
  password: ENV["ADMIN_PASSWORD"] || Rails.application.credentials.admin[:password],
  password_confirmation: ENV["ADMIN_PASSWORD"] || Rails.application.credentials.admin[:password],
  phone_number: ENV["ADMIN_PHONE_NUMBER"] || Rails.application.credentials.admin[:phone_number],
).find_or_create_by(email: ENV["ADMIN_EMAIL"] || Rails.application.credentials.admin[:email])