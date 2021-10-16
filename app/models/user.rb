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
    :omniauthable,
    :omniauth_providers => %i[github],
    :authentication_keys => {
      email: false,
      phone_number: false,
    }

  has_many :access_grants,
    class_name: 'Doorkeeper::AccessGrant',
    foreign_key: :resource_owner_id,
    dependent: :destroy

  has_many :access_tokens, 
    class_name: 'Doorkeeper::AccessToken',
    foreign_key: :resource_owner_id,
    dependent: :destroy
  
  has_many :identities,
    class_name: 'OAuth2::Identity',
    dependent: :destroy

  scope :active, -> { where(is_active: true) }
  validates :email, uniqueness: true, allow_blank: true
  validates :phone_number, uniqueness: true, allow_blank: true
  
  def email_required?
    !(phone_number.present? || identities.present?)
  end

  # Devise override to ignore the password requirement if the user is authenticated with Google
  def password_required?
    !email_required? ? false : super
  end

  def send_otp(via = 'sms', validation_hash = nil)
    if via == 'sms' || via == 'both'
      Notifications::NotifySms.perform(self.phone_number, validation_hash.present? ? I18n.t('notifications.send_sms_otp_with_hash', code: self.otp_code, validation_hash: validation_hash) : I18n.t('notifications.send_sms_otp', code: self.otp_code))
    end

    if via == 'whatsapp' || via == 'both'
      Notifications::NotifyWhatsapp.perform(self.phone_number, I18n.t('notifications.send_whatsapp_otp', code: self.otp_code))
    end
  end

  def self.from_identity(options={})
    uid, provider, email, name = options[:uid] || options[:id], options[:provider], options[:email], options[:name]
    raise "Uid is not present" unless uid.present?
    raise "Provider is not present" unless provider.present?

    identity = OAuth2::Identity.find_by(uid: uid, provider: provider)
    unless identity.present?
      identity = OAuth2::Identity.new(uid: uid, provider: provider)

      user = options[:email].present? ? User.find_by(email: options[:email]) : nil
      if user.nil?
        user = User.create(name: name, email: email, identities: [identity])
      else
        identity.user = user
        identity.save
      end
    end
    identity.user
  end 
end
