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
#

class Grant < ActiveRecord::Base
  attr_accessible :start_date, :end_date, :amount
  validates :start_date, :end_date, :amount, presence: true
end
