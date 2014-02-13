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
  scope :active, -> { where(status: "ACTIVE") }
  scope :inactive, -> { where(status: "INACTIVE") }
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
    "#{id} #{references['recipient_name']} #{references['campaign_name']} #{references['extra_info']}"
  end

  def activate(master_id, email)
    self.update_attributes(master_transaction_id: master_id, recipient_email: email)
    self.update_attribute :status, "ACTIVE"
  end

  def redeem(recipient)
    if self.redeemable?
      @charitio = Charitio.new(user.email, user.api_token)
      @transaction = @charitio.create_transaction(from: user.email,
        to: recipient.email, amount: amount.to_f, currency: "VND",
        references: references_to_string)
      if @transaction.ok?
        activate(@transaction.response["uid"], recipient.email)
        return true
      else
        logger.error(%Q{\
          [#{Time.zone.now}][Registration#create Charitio.create_transaction] \
            Affected user: #{recipient.id} / Truncated email: #{recipient.email.split('@').first} \
            API response: #{@transaction.response} \
            Params: #{{from: user.email,
                      to: recipient.email, amount: amount.to_f, currency: "VND",
                      references: references_to_string}}
          }
        )
        return false
      end
    end
  end

  def redeemable?
    status == "INACTIVE"
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
