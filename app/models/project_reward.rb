# == Schema Information
#
# Table name: project_rewards
#
#  id          :integer          not null, primary key
#  amount      :float
#  description :text
#  project_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class ProjectReward < ActiveRecord::Base
  default_scope { order('amount') }

  belongs_to :project
  has_many :donations
  
  attr_accessible :amount, :description, :project_id

  validates :amount, :description, :project_id, presence: true
  validates :amount, numericality: { greater_than_equal_to: 10000 }
end
