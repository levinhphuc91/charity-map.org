# == Schema Information
#
# Table name: redirect_tokens
#
#  id                  :integer          not null, primary key
#  value               :string(255)
#  redirect_class_name :string(255)
#  redirect_class_id   :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  extra_params        :string(255)
#

class RedirectToken < ActiveRecord::Base
  attr_accessible :redirect_class_name, :redirect_class_id, :value
 
  before_validation :generate_token
  validates :redirect_class_name, :redirect_class_id, :value, presence: true
  validates :value, uniqueness: true
 
  private
  def generate_token
    require 'securerandom'
    self.value = SecureRandom.hex(24) unless value
  end
end
