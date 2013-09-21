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
#  facebook_credentials   :hstore
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
    :verified_by_phone, :provider, :uid, :facebook_credentials

  validates :phone, :uniqueness => true, :allow_blank => true, :allow_nil => true
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

  def self.find_for_facebook_oauth(provider, uid, credentials, email, signed_in_resource=nil)
    user = User.where(:provider => provider, :uid => uid).first
    if user
      user.update :facebook_credentials => credentials
    else
      user = User.create(provider: provider,
        uid:uid,
        facebook_credentials:{
          :token => credentials.token,
          :expires_at => credentials.expires_at,
          :expires => true
          },
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

  def token_expired?
    expiry = Time.at(facebook_credentials["expires_at"].to_i)
    return true if expiry < Time.now
    false
  end
end
