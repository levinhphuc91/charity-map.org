# == Schema Information
#
# Table name: managements
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Management < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
end
