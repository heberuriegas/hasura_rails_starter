class SendOtp < HasuraHandler::Action
  action_name :send_otp

  def run
    phone_number = @input['phone_number']
    via = @input['via']
    validation_hash = @input['validation_hash']

    user = User.find_by(phone_number: phone_number)
    if user.present?
      user.send_otp(via, validation_hash)
      @output = { success: true }
    else
      @output = { success: false }
    end
    
  end
end