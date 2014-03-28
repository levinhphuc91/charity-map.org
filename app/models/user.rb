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
#  facebook_friends       :hstore
#  api_token              :string(255)
#  website                :string(255)
#  notify_via_email       :boolean
#  notify_via_sms         :boolean
#  notify_via_facebook    :boolean
#

require 'fb_graph'
require 'charitio'

class User < ActiveRecord::Base
  include Monitored
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
    :website, :provider, :uid, :facebook_credentials, :facebook_friends,
    :api_token, :verified_by_phone, :org, :figures, :latitude, :longitude,
    :notify_via_email, :notify_via_sms, :notify_via_facebook

  # before_validation :fetch_api_token

  validates :phone, :uniqueness => true, :allow_blank => true, :allow_nil => true
  # validates :api_token, presence: true
  has_many :project_comments, dependent: :destroy
  has_many :donations
  # has_many :projects, through: :donations
  has_many :projects # admin relationship
  has_many :ext_projects
  has_many :recommendations, dependent: :destroy
  has_one  :verification
  has_many :project_follows, dependent: :destroy
  has_many :relationships, :foreign_key => "follower_id", dependent: :destroy
  has_many :following, :through => :relationships, :source => :followed
  has_many :reverse_relationships, :foreign_key => "followed_id", :class_name => "Relationship"
  has_many :followers, :through => :reverse_relationships
  has_many :managements
  has_many :gift_cards
  
  has_defaults staff: false, verified_by_phone: false, org: false,
    notify_via_email: true, notify_via_sms: true, notify_via_facebook: true

  geocoded_by :address
  after_validation :geocode,
    :if => lambda{ |obj| obj.address_changed? }
  # has_settings do |s|
  #   s.key :profile, :defaults => { :portfolio => false }
  # end

  after_create :send_email_on_fundraising_projects

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
    @provider, @uid, @credentials, @email = provider, uid, credentials, email
    @user = User.find_by_email(@email)
    if (@user && !@user.facebook_access_granted?) || (@user && @user.token_expired?)
      @user.update_attributes!(provider: @provider,
        uid: @uid,
        facebook_credentials: {
          :token => @credentials.token,
          :expires_at => @credentials.expires_at,
          :expires => true
          }
        )
    elsif (!@user)
      @user = User.create!(provider: @provider,
        uid: @uid,
        facebook_credentials:{
          :token => @credentials.token,
          :expires_at => @credentials.expires_at,
          :expires => true
          },
        email: @email,
        password: Devise.friendly_token[0,20])
    end
    @user
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

  def received_gift_cards
    GiftCard.where(recipient_email: email)
  end

  def token_expired?
    expiry = Time.at(facebook_credentials["expires_at"].to_i)
    return true if expiry < Time.now
    false
  end

  def fetch_api_token
    if api_token.blank?
      @charitio = Charitio.new(email, "")
      @workoff = @charitio.create_user(email: email, category: "INDIVIDUAL")
      if @workoff.ok?
        self.api_token = @workoff.response["auth_token"]
      else
        Honeybadger.notify(error_message: %Q{\
          [#{Time.zone.now}][User#fetch_api_token Charitio.create_user] \
          Affected user: Truncated email: #{email.split('@').first} \
          API response: #{@workoff.response} \
        })
      end
    end
  end

  def facebook_access_granted?
    !facebook_credentials.nil?
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

  def fetch_fb_friends
    if !facebook_friends && !Rails.env.test?
      friend_ids = []
      @fb = FbGraph::User.new(uid, :access_token => facebook_credentials["token"])
      @fb.fetch.friends.each {|friend| friend_ids.push("#{friend.identifier}")}
      self.facebook_friends = {"ids" => friend_ids}
      self.save
    end
  end

  def send_email_on_fundraising_projects
    projects = Project.suggested_fundraising
    if (projects.count > 0) && (!OutgoingMailLog.sent?(self.email, "SuggestedProjs4NewUser"))
      UserMailer.delay(run_at: 2.days.from_now).fundraising_projects_for_new_signup(self.email, projects)
      OutgoingMailLog.create!(email: self.email,
        event: "SuggestedProjs4NewUser", 
        title: "#{projects.count} dự án đang rất cần sự hỗ trợ của bạn")
    end
  end

end
