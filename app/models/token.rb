# == Schema Information
#
# Table name: tokens
#
#  id              :integer          not null, primary key
#  value           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  ext_donation_id :integer
#  status          :string(255)
#

class Token < ActiveRecord::Base
  attr_accessible :value, :ext_donation_id, :status
  belongs_to :ext_donation
 
  before_validation :generate_token
  validates :value, :ext_donation_id, :status, presence: true
  validates :value, uniqueness: true

  has_defaults status: "UNUSED"

  def used?
    status == "USED"
  end
 
  private
  def generate_token
    require 'securerandom'
    self.value = SecureRandom.hex(24)
  end
end
