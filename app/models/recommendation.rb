# == Schema Information
#
# Table name: recommendations
#
#  id         :integer          not null, primary key
#  project_id :integer
#  user_id    :integer
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class Recommendation < ActiveRecord::Base
  attr_accessible :project_id, :user_id, :content
  belongs_to :project
  belongs_to :user

  validates :project_id, :uniqueness => {:scope => :user_id}
  validates :project_id, :user_id, :content, presence: true
  validates :project_id, :user_id, numericality: { greater_than_equal_to: 1 }
end
