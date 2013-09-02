# == Schema Information
#
# Table name: projects
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  description  :text
#  created_at   :datetime
#  updated_at   :datetime
#  start_date   :datetime
#  end_date     :datetime
#  funding_goal :float
#  location     :string(255)
#  thumbnail    :string(255)
#  user_id      :integer
#  status       :string(255)
#

class Project < ActiveRecord::Base
  attr_accessible :title, :description, :start_date, :end_date, 
    :funding_goal, :location, :thumbnail, :user_id, :status
  has_many :project_rewards
  has_many :project_updates
  has_many :project_comments
  
  has_many :donations
  has_many :users, through: :donations

  belongs_to :user # admin relationship

  validates :title, :description, :start_date, :end_date, 
    :funding_goal, :location, :status, :user_id,
    presence: true
  validates :funding_goal, numericality: { greater_than_equal_to: 100000 }

  before_validation :assign_status

  private
    def assign_status
      self.status = "DRAFT"
    end
end

# ===== PROJECT STATUSES =====
# DRAFT: default
# PENDING: project creator submitted for admin review
# REVIEWED: well, was reviewed, ready for public show
# FINISHED: done
# DELETED: deleted by project creators