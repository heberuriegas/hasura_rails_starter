class User < ApplicationRecord
  has_one_time_password length: 6

  has_one_attached :avatar

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable,
    :confirmable,
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
  validates :username, uniqueness: true, allow_blank: true

  before_create :skip_confirmation!, if: -> { !email_required? }
  
  def self.variants
    {
      thumbnail: { resize: "100x100" },
    }
  end

  def avatar_variant(size)
    self.avatar.variant(User.variants[size]).processed
  end
  
  def auth_by_phone_number?
    !email_required? && phone_number.present?
  end

  def email_required?
    !(phone_number.present? || identities.present?)
  end

  # Devise override to ignore the password requirement if the user is authenticated with Google
  def password_required?
    !email_required? ? false : super
  end

  def send_otp(options = {})
    options.reverse_merge!(via: 'sms', validation_hash: nil)
    via, validation_hash = *options.values_at(:via, :validation_hash)
    
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

  def avatar_url
    ENV['HOST']+Rails.application.routes.url_helpers.rails_blob_path(avatar, only_path: true) if avatar.attached?
  end

  def avatar_thumbnail_url
    ENV['HOST']+Rails.application.routes.url_helpers.rails_representation_url(avatar_variant(:thumbnail).processed, only_path: true)
  end
end
