# == Schema Information
#
# Table name: project_updates
#
#  id         :integer          not null, primary key
#  content    :text
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#  photo      :string(255)
#  title      :string(255)
#

class ProjectUpdate < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader
  default_scope { order('updated_at DESC') }
  belongs_to :project

  attr_accessible :title, :content, :project_id, :photo, :photo_cache

  validates :title, :content, :project_id, presence: true
end
