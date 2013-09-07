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
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  mount_uploader :avatar, AvatarUploader
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :id, :email, :password, :password_confirmation,
    :full_name, :address, :city, :bio, :phone, :avatar, :avatar_cache,
    :verified_by_phone

  has_many :project_comments
  has_many :donations
  has_many :projects, through: :donations
  has_many :projects # admin relationship
  has_many :recommendations
  
  has_defaults staff: false, verified_by_phone: false

  def blank_contact?
    return true if (self.phone.nil? || self.phone.empty?) || (self.address.nil? || self.address.empty?)
    false
  end
end
