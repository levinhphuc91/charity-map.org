# == Schema Information
#
# Table name: project_follows
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class ProjectFollow < ActiveRecord::Base

  belongs_to :user
  belongs_to :project

  attr_accessible  :project_id, :user_id
  validates :user_id, :project_id, presence: true
end
