# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  full_name              :string(255)
#  address                :string(255)
#  city                   :string(255)
#  bio                    :text
#  phone                  :string(255)
#  staff                  :boolean
#  avatar                 :string(255)
#  verified_by_phone      :boolean
#  provider               :string(255)
#  uid                    :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  mount_uploader :avatar, AvatarUploader
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  attr_accessible :id, :email, :password, :password_confirmation,
    :full_name, :address, :city, :bio, :phone, :avatar, :avatar_cache,
    :verified_by_phone, :provider, :uid

  validates :phone, :uniqueness => true
  has_many :project_comments
  has_many :donations
  has_many :projects, through: :donations
  has_many :projects # admin relationship
  has_many :recommendations
  has_many :verifications
  
  has_defaults staff: false, verified_by_phone: false

  def blank_contact?
    return true if (self.phone.blank?) || (self.address.blank?) || (self.full_name.blank?)
    false
  end

  def verified?
    self.verified_by_phone
  end

  def self.find_for_facebook_oauth(provider, uid, email, signed_in_resource=nil)
    user = User.where(:provider => provider, :uid => uid).first
    unless user
      user = User.create(provider: provider,
        uid:uid,
        email:email,
        password:Devise.friendly_token[0,20])
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
