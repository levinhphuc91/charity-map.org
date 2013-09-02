# == Schema Information
#
# Table name: donations
#
#  id                :integer          not null, primary key
#  euid              :string(255)
#  status            :string(255)
#  user_id           :integer
#  amount            :float
#  note              :text
#  collection_method :string(255)
#  project_reward_id :integer
#  project_id        :integer
#  created_at        :datetime
#  updated_at        :datetime
#

class Donation < ActiveRecord::Base
  attr_accessible :euid, :status, :user_id, :amount, :note, :collection_method, :project_reward_id, :project_id
  belongs_to :user
  belongs_to :project
  belongs_to :project_reward

  validates :user_id, :project_id, :euid,
    presence: true

  before_validation :assign_euid

  private
    def generate_random_string
      (0...5).map{ ('0'..'9').to_a[rand(10)] }.join
    end
    def assign_euid
      self.euid = generate_random_string if euid == nil
    end
end
