# == Schema Information
#
# Table name: invites
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  phone      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  project_id :integer
#  status     :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invite do
    name "MyString"
    email "MyString"
    phone "MyString"
  end
end
