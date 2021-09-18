class Notifications::NotifySms < Aldous::Service
  attr_reader :phone_number
  attr_reader :message

  def initialize phone_number, message
    @phone_number = phone_number
    @message = message
  end

  def perform
    TWILIO.messages.create(
      body: message,
      from: TWILIO_PHONE_NUMBER,
      to: "+#{phone_number}"
    )
    return Result::Success.new
  end
end