# == Schema Information
#
# Table name: configurations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  value      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :configuration do
    name "MyString"
    value "MyString"
  end
end
