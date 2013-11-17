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
#  brief        :text
#  video        :string(255)
#  settings     :hstore
#  unlisted     :boolean
#  address      :string(255)
#  latitude     :float
#  longitude    :float
#  category_id  :integer
#

class Project < ActiveRecord::Base
  scope :pending, -> { where(status: "PENDING") }
  scope :listed, -> { where(unlisted: false) }
  scope :funding, -> { where("STATUS = ? AND START_DATE < ? AND END_DATE > ? AND UNLISTED = ?",
    "REVIEWED", Time.now, Time.now, "f").order("created_at DESC") }
  scope :finished, -> { where(status: "FINISHED", unlisted: false).order("created_at DESC") }
  scope :mapped, -> { where("LATITUDE >= ? AND LONGITUDE >= ?", 0, 0) }
  scope :public_view, -> { where(status: ["REVIEWED", "FINISHED"], unlisted: false).order("created_at DESC") }

  attr_accessible :title, :brief, :description, :start_date, :end_date, 
    :funding_goal, :location, :photo, :photo_cache, :user_id, :status, :video,
    :address, :latitude, :longitude

  has_many :project_rewards
  has_many :project_updates
  has_many :project_comments
  has_many :donations
  has_many :users, through: :donations
  has_many :recommendations
  has_many :project_follows
  belongs_to :user # admin relationship

  before_validation :assign_status
  
  validates :title, :description, :start_date, :end_date, 
    :funding_goal, :location, :status, :user_id, :brief,
    presence: true
  validates_length_of :brief, :minimum => 20, :maximum => 200, :allow_blank => true
  validates :funding_goal, numericality: { greater_than_equal_to: 100000 }
  validates :user_id, numericality: { greater_than: 0 }
  validate :start_date_cannot_be_in_the_past, :funding_duration_to_be_less_than_six_months
  validate :video_url_to_be_a_valid_service_link
  
  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode,
    :if => lambda{ |obj| obj.address_changed? }

  extend FriendlyId
  friendly_id :title, use: :slugged
  mount_uploader :photo, PhotoUploader
  has_defaults unlisted: true

  def accepting_donation?
    status == "REVIEWED" 
    # && start_date < Date.today && end_date > Date.today
  end

  def belongs_to?(target_user)
    return true if self.user == target_user
    false
  end

  private
    def assign_status
      self.status = "DRAFT" if status == nil
    end

    def start_date_cannot_be_in_the_past
      errors.add(:start_date, "can't be in the past") if
        start_date.blank? and start_date < Date.today
    end

    def funding_duration_to_be_less_than_six_months
      errors.add(:end_date, "can't be more than 6 months from start date") if
        !start_date.blank? and !end_date.blank? and TimeDifference.between(end_date, start_date).in_days > 180
    end

    def video_url_to_be_a_valid_service_link
      youtube_regex = /^(?:https?:\/\/)?(?:www\.)?(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((\w|-){11})(?:\S+)?$/
      vimeo_regex = /^(http\:\/\/|https\:\/\/)?(www\.)?(vimeo\.com\/)([0-9]+)$/
      errors.add(:video, "only valid Vimeo or YouTube URLs are allowed") if
        (!video.blank?) && !youtube_regex.match(video) && !vimeo_regex.match(video)
    end
end
