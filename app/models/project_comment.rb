# == Schema Information
#
# Table name: project_comments
#
#  id         :integer          not null, primary key
#  content    :text
#  user_id    :integer
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class ProjectComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
end
