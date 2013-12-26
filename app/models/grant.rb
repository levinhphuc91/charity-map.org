# == Schema Information
#
# Table name: grants
#
#  id         :integer          not null, primary key
#  start_date :datetime
#  end_date   :datetime
#  amount     :float
#  created_at :datetime
#  updated_at :datetime
#  name       :string(255)
#  giver      :string(255)
#

class Grant < ActiveRecord::Base
  attr_accessible :name, :giver, :start_date, :end_date, :amount
  validates :name, :giver, :start_date, :end_date, :amount, presence: true
end
