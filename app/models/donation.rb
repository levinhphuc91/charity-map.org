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
#  anon                    :boolean
#

class Donation < ActiveRecord::Base
  include DonationsHelper
  scope :successful, -> { where(status: "SUCCESSFUL") }
  default_scope { where.not(status: "FAILED") }

  attr_accessible :euid, :status, :user_id, :amount, :note,
    :anon, :collection_method, :project_id, :token_id,
    :project_reward_id, :project_reward_quantity,
    :created_at

  belongs_to :user
  belongs_to :project
  belongs_to :project_reward

  has_defaults status: "PENDING", project_reward_quantity: 1, anon: false
  before_validation :assign_euid
  before_validation :calculate_amount
  before_validation :assign_project_reward_id, on: :create

  validates :user_id, :project_id, :euid, :status, :project_reward_id,
    :amount, :collection_method, presence: true
  validate :amount_can_not_be_smaller_than_least_reward
  validate :quantity_can_not_be_bigger_than_left_items, on: :create

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

  def confirm!
    self.update_attributes! status: "SUCCESSFUL"
  end

  private

    def amount_can_not_be_smaller_than_least_reward
      errors.add(:amount, "không thể ít hơn #{self.project.project_rewards[0].value.to_i}VNĐ") if
        !(self.project.project_rewards.empty?) and !amount.blank? and (amount < self.project.project_rewards[0].value)
    end
    # viet test TODO

    def quantity_can_not_be_bigger_than_left_items
      if self.project.item_based
        errors.add(:project_reward_quantity, "không thể nhiều hơn #{self.project_reward.active_item}") if
          project_reward_quantity > self.project_reward.active_item
      end
    end
    # viet test TODO

    def generate_random_string
      (0..4).map{ ('0'..'9').to_a[rand(10)] }.join
    end

    def assign_euid
      self.euid = generate_random_string if euid == nil
    end

    def assign_project_reward_id
      self.project_reward_id = auto_select_project_reward(self.project, self.amount) if project_reward_id.blank?
    end
end
