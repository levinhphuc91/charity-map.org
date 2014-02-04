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
#  anon              :boolean
#  status            :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ext_donation do
    project nil
    amount 1.5
    note "MyText"
    collection_method "MyString"
    donor "MyString"
  end
end
