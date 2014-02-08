# == Schema Information
#
# Table name: gift_cards
#
#  id                    :integer          not null, primary key
#  recipient_email       :string(255)
#  amount                :float
#  references            :hstore
#  created_at            :datetime
#  updated_at            :datetime
#  user_id               :integer
#  status                :string(255)
#  master_transaction_id :string(255)
#

class GiftCard < ActiveRecord::Base
  belongs_to :user
  attr_accessible :master_transaction_id, :recipient_email, :amount, :references
  validates :recipient_email, :amount, :user_id, :master_transaction_id, presence: true
  has_defaults status: "ACTIVE"
end
