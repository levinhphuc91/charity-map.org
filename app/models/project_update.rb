# == Schema Information
#
# Table name: project_updates
#
#  id         :integer          not null, primary key
#  content    :text
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class ProjectUpdate < ActiveRecord::Base
  belongs_to :project
end
