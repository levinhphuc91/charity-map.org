# == Schema Information
#
# Table name: tokens
#
#  id              :integer          not null, primary key
#  value           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  ext_donation_id :integer
#  status          :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :token do
    value "MyString"
    created_for "MyString"
    parent_id 1
  end
end
