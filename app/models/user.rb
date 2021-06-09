class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable
  include GraphqlDevise::Concerns::Model
  
  before_create :default_role

  ROLES = {
    admin: 'admin',
    user: 'user'
  }

  private
  def default_role
    self.role = ROLES[:user] unless self.role?
  end
end
