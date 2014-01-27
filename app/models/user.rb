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
#  org                    :boolean
#  figures                :hstore
#  latitude               :float
#  longitude              :float
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  mount_uploader :avatar, AvatarUploader
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]
  acts_as_messageable  :table_name => "messages",
                      :required   => :body,
                      :class_name => "ActsAsMessageable::Message",
                      :dependent  => :destroy,
                      :group_messages => false
                      
  attr_accessible :id, :email, :password, :password_confirmation,
    :full_name, :address, :city, :bio, :phone, :avatar, :avatar_cache,
    :provider, :uid, :facebook_credentials, :facebook_friends,
    :verified_by_phone, :org, :figures, :latitude, :longitude

  validates :phone, :uniqueness => true, :allow_blank => true, :allow_nil => true
  has_many :project_comments
  has_many :donations
  has_many :projects, through: :donations
  has_many :projects # admin relationship
  has_many :ext_projects
  has_many :recommendations
  has_one  :verification
  has_many :project_follows
  has_many :relationships, :foreign_key => "follower_id", dependent: :destroy
  has_many :following, :through => :relationships, :source => :followed
  has_many :reverse_relationships, :foreign_key => "followed_id", :class_name => "Relationship"
  has_many :followers, :through => :reverse_relationships
  
  has_defaults staff: false, verified_by_phone: false, org: false

  geocoded_by :address
  after_validation :geocode,
    :if => lambda{ |obj| obj.address_changed? }
  # has_settings do |s|
  #   s.key :profile, :defaults => { :portfolio => false }
  # end

  def name
    return full_name unless full_name.blank?
    email.split("@").first
  end

  def blank_contact?
    return true if (self.phone.blank?) || (self.address.blank?) || (self.full_name.blank?)
    false
  end

  def verified?
    self.verified_by_phone
  end

  def self.find_for_facebook_oauth(provider, uid, credentials, email, signed_in_resource=nil)
    user = User.find_by_email(email)
    if (user && !user.facebook_access_granted?)
      user.update_attributes!(provider: provider,
        uid: uid,
        facebook_credentials: {
          :token => credentials.token,
          :expires_at => credentials.expires_at,
          :expires => true
          }
        )
    elsif (!user)
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

  def coordinated?
    return true if (latitude && longitude && latitude >= 0 && longitude >= 0)
    false
  end

  def token_expired?
    expiry = Time.at(facebook_credentials["expires_at"].to_i)
    return true if expiry < Time.now
    false
  end

  def facebook_access_granted?
    return true if facebook_credentials
    false
  end

  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end

  # def fetch_fb_friends
  #   if !facebook_friends #&& Rails.env.production?
  #     friend_ids = []
  #     @fb = FbGraph::User.fetch(uid, :access_token => facebook_credentials["token"])
  #     @fb.friends.each {|friend| friend_ids.push("#{friend.identifier}")}
  #     self.update_attribute! :facebook_friends, friend_ids
  #   end
  # end
end
