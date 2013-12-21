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
#  token_id          :integer
#

class Donation < ActiveRecord::Base
  scope :successful, -> { where(status: "SUCCESSFUL") }

  attr_accessible :euid, :status, :user_id, :amount, :note,
    :collection_method, :project_reward_id, :project_id

  belongs_to :user
  belongs_to :project
  belongs_to :project_reward

  has_defaults status: "PENDING"
  before_validation :assign_euid

  validates :user_id, :project_id, :euid, :status, :project_reward_id,
    :amount, :collection_method, presence: true
  validate :amount_can_not_be_smaller_than_least_reward

  def belongs_to?(target_user)
    return true if self.user == target_user
    false
  end

  private

    def amount_can_not_be_smaller_than_least_reward
      errors.add(:amount, "can't be smaller than least reward") if
        !(self.project.project_rewards.empty?) and !amount.blank? and (amount < self.project.project_rewards[0].amount)
    end
    # viet test TODO

    def generate_random_string
      (0..4).map{ ('0'..'9').to_a[rand(10)] }.join
    end

    def assign_euid
      self.euid = generate_random_string if euid == nil
    end
end
