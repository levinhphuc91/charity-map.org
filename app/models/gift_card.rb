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
#  token                 :string(255)
#

class GiftCard < ActiveRecord::Base
  belongs_to :user
  attr_accessible :master_transaction_id, :recipient_email, :amount, :references, :user_id, :token
  before_validation :generate_token

  validates :recipient_email, :amount, :user_id, :token, presence: true
  validate :transaction_id_on_being_active
  has_defaults status: "INACTIVE"

  def transaction_id_on_being_active
    errors.add(:status, "can't be active without proper master_transaction_id") if
      status == "ACTIVE" && master_transaction_id.blank?
  end

  def references_to_string
    "#{references['recipient_name']} #{references['campaign_name']} #{references['extra_info']}"
  end

  def activate(master_id)
    self.update_attribute :master_transaction_id, master_id
    self.update_attribute :status, "ACTIVE"
  end

  private
  def generate_token
    require 'securerandom'
    self.token = loop do
      random_value = SecureRandom.hex(3)
      break random_value unless GiftCard.exists?(token: random_value)
    end
  end
end
