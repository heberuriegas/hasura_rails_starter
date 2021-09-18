TWILIO = Twilio::REST::Client.new(
  ENV["TWILIO_ACCOUNT_SID"] || Rails.application.credentials.twilio[:account_sid],
  ENV["TWILIO_AUTH_TOKEN"] || Rails.application.credentials.twilio[:auth_token]
)

TWILIO_PHONE_NUMBER = ENV["TWILIO_PHONE_NUMBER"] || Rails.application.credentials.twilio[:phone_number]