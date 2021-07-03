class User < ApplicationRecord
  has_one_time_password length: 6

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable
  include GraphqlDevise::Concerns::Model

  validates :email, uniqueness: true, allow_blank: true
  validates :phone_number, uniqueness: true, allow_blank: true
  
  before_create :set_default_role
  before_validation :set_default_uid

  ROLES = {
    admin: 'admin',
    user: 'user'
  }

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
      message = TWILIO.messages.create(
        body: validation_hash.present? ? I18n.t('notifications.send_sms_otp_with_hash', code: self.otp_code, validation_hash: validation_hash) : I18n.t('notifications.send_sms_otp', code: self.otp_code),
        from: ENV['TWILIO_PHONE_NUMBER'],
        to: "+#{self.phone_number}"
      )
    end

    if via == 'whatsapp' || via == 'both'
      message = TWILIO.messages.create(
        body: I18n.t('notifications.send_whatsapp_otp', code: self.otp_code),
        from: "whatsapp:#{ENV['TWILIO_PHONE_NUMBER']}",
        to: "whatsapp:+#{self.phone_number}"
      )
    end
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
