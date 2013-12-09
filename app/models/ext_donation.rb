# == Schema Information
#
# Table name: ext_donations
#
#  id                :integer          not null, primary key
#  project_id        :integer
#  amount            :float
#  note              :text
#  collection_method :string(255)
#  donor             :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  collection_time   :datetime
#  email             :string(255)
#  phone             :string(255)
#

class ExtDonation < ActiveRecord::Base
  belongs_to :project
  attr_accessible :donor, :amount, :note, :email, :phone,
    :collection_method, :collection_time, :project_id
  validates :donor, :amount, :collection_time, :project_id, presence: true
  has_defaults donor: "Anonymous"
end
