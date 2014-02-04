# == Schema Information
#
# Table name: recommendations
#
#  id         :integer          not null, primary key
#  project_id :integer
#  user_id    :integer
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :recommendation do
    project nil
    user nil
    content "MyText"
  end
end
