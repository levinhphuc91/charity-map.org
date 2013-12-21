# == Schema Information
#
# Table name: tokens
#
#  id          :integer          not null, primary key
#  value       :string(255)
#  created_for :string(255)
#  parent_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Token < ActiveRecord::Base
  attr_accessible :value, :created_for, :parent_id
 
  before_validation :generate_token
  validates :value, :created_for, :parent_id, presence: true
 
  private
  def generate_token
    require 'securerandom'
    self.value = SecureRandom.hex(24)
  end
end
