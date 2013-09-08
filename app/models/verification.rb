# == Schema Information
#
# Table name: verifications
#
#  id         :integer          not null, primary key
#  code       :string(255)
#  user_id    :integer
#  channel    :string(255)
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Verification < ActiveRecord::Base
  attr_accessible :code, :user_id, :channel, :status
  belongs_to :user
  validates :code, :channel, :user_id, :status, presence: true
  validates :user_id, :uniqueness => {:scope => :channel}

  before_validation :assign_code
  has_defaults :status => "UNUSED", :channel => "PHONE"

  def generate_random_string
    (0..5).map{ ('0'..'9').to_a[rand(10)] }.join
  end

  def assign_code
    self.code = generate_random_string if code == nil
  end
end
