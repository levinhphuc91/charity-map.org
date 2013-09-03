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
#  photo        :string(255)
#  user_id      :integer
#  status       :string(255)
#  slug         :string(255)
#

class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  mount_uploader :photo, PhotoUploader
  scope :draft, -> { where(status: "DRAFT") }
  scope :funding, -> { where("STATUS = ? AND START_DATE < ? AND END_DATE > ?", "REVIEWED", Time.now, Time.now) }
  scope :finished, -> { where(status: "FINISHED") }
  scope :public_view, -> { where(status: ["REVIEWED", "FINISHED"]) }

  attr_accessible :title, :description, :start_date, :end_date, 
    :funding_goal, :location, :photo, :photo_cache, :user_id, :status
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
  validates :user_id, numericality: { greater_than: 0 }
  validate :start_date_cannot_be_in_the_past, :funding_duration_to_be_less_than_six_months

  before_validation :assign_status

  private
    def assign_status
      self.status = "DRAFT" if status == nil
    end

    def start_date_cannot_be_in_the_past
      errors.add(:start_date, "can't be in the past") if
        !start_date.blank? and start_date < Date.today
    end

    def funding_duration_to_be_less_than_six_months
      errors.add(:end_date, "can't be more than 6 months from start date") if
        !start_date.blank? and !end_date.blank? and TimeDifference.between(end_date, start_date).in_days > 180
    end
end

# ===== PROJECT STATUSES =====
# DRAFT: default
# PENDING: project creator submitted for admin review
# REVIEWED: well, was reviewed, ready for public show
# FINISHED: done
# DELETED: deleted by project creators
