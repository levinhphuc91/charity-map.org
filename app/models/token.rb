# == Schema Information
#
# Table name: tokens
#
#  id              :integer          not null, primary key
#  value           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  ext_donation_id :integer
#

class Token < ActiveRecord::Base
  attr_accessible :value, :ext_donation_id
  belongs_to :ext_donation
 
  before_validation :generate_token
  validates :value, :ext_donation_id, presence: true
  validates :value, uniqueness: true
 
  private
  def generate_token
    require 'securerandom'
    self.value = SecureRandom.hex(24)
  end
end
