module OAuth2
  class Assertion < ApplicationRecord
    self.table_name = 'oauth_assertions'
    belongs_to :user

    validates_presence_of :provider
    validates_presence_of :uid
  end
end