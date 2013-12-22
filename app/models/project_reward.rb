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
  
  attr_accessible :name, :value, :photo, :description, :quantity, :project_id

  validates :value, :description, :project_id, presence: true
  validates :value, numericality: { :greater_than_or_equal_to => 10000 }
  validates :value, :uniqueness => {:scope => :project_id}
end
