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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gift_card do
    recipient_email "MyString"
    amount 1.5
    references ""
  end
end
