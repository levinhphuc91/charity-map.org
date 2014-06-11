# == Schema Information
#
# Table name: invites
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  phone      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  project_id :integer
#  status     :string(255)
#

class Invite < ActiveRecord::Base
  scope :fresh, -> { where(status: "NEW") }
  scope :sent, -> { where(status: "SENT") }
  belongs_to :project
  attr_accessible :project_id, :name, :email, :phone, :status
  validates :name, presence: true
  validates :email, uniqueness: {scope: :project_id}, allow_blank: true
  has_defaults status: "NEW"

  def sent?
    return true if status == "SENT"
    false
  end

  def new?
    return true if status == "NEW"
    false
  end
end
