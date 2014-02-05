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
  attr_accessible :user_id, :project_id
  belongs_to :user
  belongs_to :project
  validates :user_id, :project_id, presence: true
end
