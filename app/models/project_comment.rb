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
#  photo      :string(255)
#

class ProjectComment < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader

  belongs_to :user
  belongs_to :project

  attr_accessible :content, :project_id, :user_id, :photo, :photo_cache
  validates :content, :user_id, :project_id, presence: true
end
