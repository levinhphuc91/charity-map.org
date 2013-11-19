# == Schema Information
#
# Table name: ext_projects
#
#  id               :integer          not null, primary key
#  photo            :string(255)
#  title            :string(255)
#  location         :string(255)
#  funding_goal     :float
#  number_of_donors :integer
#  executed_at      :datetime
#  description      :text
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#  address          :string(255)
#  latitude         :float
#  longitude        :float
#

class ExtProject < ActiveRecord::Base
  scope :mapped, -> { where("LATITUDE >= ? AND LONGITUDE >= ?", 0, 0) }

  belongs_to :user
  mount_uploader :photo, PhotoUploader
  attr_accessible :title, :location, :description,
    :funding_goal, :number_of_donors, :executed_at,
    :photo, :user_id

  validates :title, :location, :description,
    :funding_goal, :number_of_donors, :executed_at,
    :photo, :user_id, presence: true
end
