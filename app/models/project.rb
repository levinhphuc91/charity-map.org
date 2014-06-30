# == Schema Information
#
# Table name: projects
#
#  id                   :integer          not null, primary key
#  title                :string(255)
#  description          :text
#  created_at           :datetime
#  updated_at           :datetime
#  start_date           :datetime
#  end_date             :datetime
#  funding_goal         :float
#  location             :string(255)
#  photo                :string(255)
#  user_id              :integer
#  status               :string(255)
#  slug                 :string(255)
#  brief                :text
#  video                :string(255)
#  unlisted             :boolean
#  address              :string(255)
#  latitude             :float
#  longitude            :float
#  invite_email_content :text
#  invite_sms_content   :string(255)
#  short_code           :string(255)
#  bank_info            :text
#  item_based           :boolean
#

class Project < ActiveRecord::Base
  scope :pending, -> { where(status: "PENDING") }
  scope :listed, -> { where(unlisted: false) }
  scope :funding, -> { where("STATUS = ? AND START_DATE < ? AND END_DATE > ? AND UNLISTED = ?",
    "REVIEWED", Time.now, Time.now, "false").order("created_at DESC") }
  scope :finished, -> { where("STATUS = ? AND END_DATE < ? AND UNLISTED = ?",
    "REVIEWED", Time.now, "false").order("created_at DESC") }
  scope :mapped, -> { where("LATITUDE IS NOT ? AND LONGITUDE IS NOT ?", nil, nil) }
  scope :public_view, -> { where(status: ["REVIEWED", "FINISHED"], unlisted: false).order("created_at DESC") }
  scope :portfolio_view, -> { where(status: ["REVIEWED", "FINISHED"]).order("created_at DESC") }
  scope :suggested_fundraising, -> { where(status: ["REVIEWED"], unlisted: false).order("created_at DESC").select {|project| project.accepting_donations? && !project.success?} }

  attr_accessible :short_code, :title, :brief, :description, :start_date, :end_date, 
    :bank_info, :funding_goal, :location, :photo, :photo_cache, :user_id, :status, :item_based,
    :video, :address, :latitude, :longitude, :slug, :invite_email_content, :invite_sms_content

  # is_impressionable
  has_many :invites
  has_many :project_rewards
  has_many :project_updates, dependent: :destroy
  has_many :project_comments, dependent: :destroy
  has_many :donations
  has_many :ext_donations
  has_many :users, through: :donations
  has_many :recommendations
  has_many :project_follows
  belongs_to :user # admin relationship
  has_many :managements
  has_many :editors, through: :managements, source: :user

  before_validation :assign_status
  before_validation :generate_short_code
  
  validates :short_code, length: {minimum: 4, maximum: 6}, allow_blank: true
  validates :title, :description, :start_date, :end_date, 
    :funding_goal, :location, :status, :user_id, :brief,
    presence: true
  validates :invite_sms_content, length: { maximum: 160 }
  validates_length_of :brief, :minimum => 20, :maximum => 200, :allow_blank => true
  validates :funding_goal, numericality: { greater_than_equal_to: 100000 }
  validates :user_id, numericality: { greater_than: 0 }
  validate :start_date_cannot_be_in_the_past, :funding_duration_to_be_less_than_six_months
  validate :video_url_to_be_a_valid_service_link
  
  geocoded_by :location
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode,
    :if => lambda{ |obj| obj.location_changed? }

  extend FriendlyId
  friendly_id :title, use: :slugged

  def coordinated?
    return true if (latitude && longitude && latitude >= 0 && longitude >= 0)
    false
  end

  def sms_credit
    return (100 - self.invites.sent.where("phone <> ''").count)
  end

  def normalize_friendly_id(string)
    string.to_s.to_slug.normalize(transliterations: :vietnamese).to_s
  end
  
  mount_uploader :photo, PhotoUploader
  has_defaults unlisted: true, item_based: false

  def donations_count
    count = self.donations.successful.count + self.ext_donations.count
    return count
  end

  def donations_sum
    donations.successful.sum(:amount) + ext_donations.sum(:amount)
  end

  def donations_average
    average = self.ext_donations.maximum(:amount)
    return average.to_i
  end

  def accepting_donations?
    status == "REVIEWED" && start_date < Time.now && end_date > Time.now
  end

  def success?
    donations_sum > (funding_goal*75/100)
  end

  def belongs_to?(target_user)
    return true if (self.user == target_user) || (target_user.staff)
    false
  end

  def authorized_edit_for?(target_user)
    (self.belongs_to?(target_user)) || (target_user.staff) || (self.editors.exists?(target_user))
  end

  def authorized_super_edit_for?(target_user)
    (self.belongs_to?(target_user)) || (target_user.staff)
  end

  def generate_short_code
    if short_code.blank?
      abbr = ""
      title.to_s.to_slug.normalize(transliterations: :vietnamese).to_s.split("-")[0..3].each do |a|
        abbr += a[0]
      end
      abbr = title[0..3] if title.split.count < 4
      self.short_code = abbr
    end
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
