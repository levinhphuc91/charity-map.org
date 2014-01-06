# == Schema Information
#
# Table name: project_rewards
#
#  id          :integer          not null, primary key
#  value       :float
#  description :text
#  project_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#  name        :string(255)
#  photo       :string(255)
#  quantity    :integer
#

class ProjectReward < ActiveRecord::Base
  default_scope { order('value') }

  belongs_to :project
  has_many :donations
  mount_uploader :photo, ItemUploader

  attr_accessible :name, :value, :photo, :description, :quantity, :project_id

  validates :value, :description, :project_id, presence: true
  validates :value, numericality: { :greater_than_or_equal_to => 10000 }
  # validates :value, :uniqueness => {:scope => :project_id}
  validate :quantity_can_not_be_nil_for_item_based_projects

  def active_item
    return (quantity - self.project.donations.successful.where(:project_reward_id => self.id).count)
  end

  private
    def quantity_can_not_be_nil_for_item_based_projects
      if self.project.item_based?
        errors.add(:quantity, "không thể bỏ trống") if quantity.blank?
      end
    end
    # TODO: ADD TEST?
end
