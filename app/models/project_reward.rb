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
  belongs_to :project
  has_many :donations
end
