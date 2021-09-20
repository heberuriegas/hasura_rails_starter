class User < ApplicationRecord
  has_one_time_password length: 6

  has_one_attached :avatar

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable,
    :authentication_keys => {
      email: false,
      phone_number: false,
    }
  include GraphqlDevise::Concerns::Model
  # Devise omniauthable redefinition is required https://github.com/lynndylanhurley/devise_token_auth/issues/666
  devise :omniauthable, omniauth_providers: %i[]

  scope :active, -> { where(is_active: true) }
  validates :email, uniqueness: true, allow_blank: true
  validates :phone_number, uniqueness: true, allow_blank: true
  
  before_create :set_default_role
  before_validation :set_default_uid

  ROLES = {
    admin: 'admin',
    user: 'user'
  }

  def admin?
    self.role == 'admin'
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def create_token(client: nil, lifespan: nil, cost: nil, **token_extras)
    token = DeviseTokenAuth::TokenFactory.create(client: client, lifespan: lifespan, cost: cost)

    tokens[token.client] = {
      token:  token.token_hash,
      last_token: token.token_hash,
      expiry: token.expiry
    }.merge!(token_extras.except(:last_token))

    clean_old_tokens

    token
  end

  def create_new_auth_token(client = nil)
    now = Time.zone.now

    token = create_token(
      client: client,
      last_token: tokens.fetch(client, {})['token'],
      updated_at: now
    )

    update_auth_header(token.token, token.client)
  end

  def send_otp(via = 'sms', validation_hash = nil)
    if via == 'sms' || via == 'both'
      Notifications::NotifySms.perform(self.phone_number, validation_hash.present? ? I18n.t('notifications.send_sms_otp_with_hash', code: self.otp_code, validation_hash: validation_hash) : I18n.t('notifications.send_sms_otp', code: self.otp_code))
    end

    if via == 'whatsapp' || via == 'both'
      Notifications::NotifyWhatsapp.perform(self.phone_number, I18n.t('notifications.send_whatsapp_otp', code: self.otp_code))
    end
  end

  # Devise override to ignore the password requirement if the user is authenticated with Google
  def password_required?
    provider.present? ? false : super
  end

  def self.from_omniauth(auth)
    user = where(email: auth.info.email).first || where(where(provider: auth.provider, uid: auth.uid)).first || new
    user.update provider: auth.provider, uid: auth.uid, email: auth.info.email
    user.name ||= auth.info.name # note: Devise seems to wrap this in the DB write for session info
    user
  end

  protected
  def destroy_expired_tokens
    if tokens
      tokens.delete_if do |cid, v|
        expiry = v[:expiry] || v['expiry']
        DateTime.strptime(expiry.to_s, '%s') < Time.zone.now && !v[:last_token]
      end
    end
  end

  private
  def set_default_role
    self.role = ROLES[:user] unless self.role?
  end

  def set_default_uid
    self.uid = self.email || self.phone_number
  end
end
