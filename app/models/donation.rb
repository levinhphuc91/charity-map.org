# == Schema Information
#
# Table name: donations
#
#  id                      :integer          not null, primary key
#  euid                    :string(255)
#  status                  :string(255)
#  user_id                 :integer
#  amount                  :float
#  note                    :text
#  collection_method       :string(255)
#  project_reward_id       :integer
#  project_id              :integer
#  created_at              :datetime
#  updated_at              :datetime
#  project_reward_quantity :integer
#

class Donation < ActiveRecord::Base
  scope :successful, -> { where(status: "SUCCESSFUL") }

  attr_accessible :euid, :status, :user_id, :amount, :note,
    :collection_method, :project_id, :token_id,
    :project_reward_id, :project_reward_quantity

  belongs_to :user
  belongs_to :project
  belongs_to :project_reward

  has_defaults status: "PENDING", project_reward_quantity: 1
  before_validation :assign_euid
  before_validation :calculate_amount

  validates :user_id, :project_id, :euid, :status, :project_reward_id,
    :amount, :collection_method, presence: true
  validate :amount_can_not_be_smaller_than_least_reward

  def belongs_to?(target_user)
    return true if self.user == target_user
    false
  end

  def calculate_amount
    if self.project.item_based
      @reward = ProjectReward.find(self.project_reward_id)
      self.amount = @reward.value * self.project_reward_quantity
    end
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
