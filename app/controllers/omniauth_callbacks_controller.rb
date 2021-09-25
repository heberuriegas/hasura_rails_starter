class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all

    auth = request.env['omniauth.auth']

    @identity = Identity.find_or_create_by(uid: auth.uid, provider: auth.provider).create_with(
      user: User.create(name: auth.info.name, email: auth.info.email)
    )
  
    if current_user.present?
      if @identity.user == current_user
        redirect_to root_url, notice: "Already linked that account!"
      else
        @identity.user = current_user
        @identity.save
        redirect_to root_url, notice: "Successfully linked that account!"
      end
    else
      if @identity.user.persisted?
        sign_in_and_redirect @identity.user, event: :authentication
      else
        redirect_to new_user_session_path, notice: "We couldn't sign you in because: " + user.errors.full_messages.to_sentence
      end
    end
  end
  
  # alias_method :google, :all
  alias_method :github, :all
end