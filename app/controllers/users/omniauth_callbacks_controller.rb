class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token

  def all
    user = User.from_omniauth request.env["omniauth.auth"]
    if user.persisted?
      flash.notice = "Signed in!"
      sign_in_and_redirect user
    else
      flash.notice = "We couldn't sign you in because: " + user.errors.full_messages.to_sentence
      redirect_to new_user_session_url
    end
  end
  
  # alias_method :google, :all
  alias_method :github, :all
end