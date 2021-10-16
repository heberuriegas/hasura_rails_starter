module OAuth2
  class Identity < ApplicationRecord
    self.table_name = 'oauth_identities'
    belongs_to :user

    validates_presence_of :provider
    validates_presence_of :uid

    def self.find_with_omniauth(auth)
      find_by(uid: auth['uid'] || auth['id'], provider: auth['provider'])
    end
  
    def self.create_with_omniauth(auth)
      create(uid: auth['uid'] || auth['id'], provider: auth['provider'])
    end
  end
end
