# == Schema Information
#
# Table name: ext_projects
#
#  id               :integer          not null, primary key
#  photo            :string(255)
#  title            :string(255)
#  location         :string(255)
#  funding_goal     :float
#  number_of_donors :integer
#  executed_at      :datetime
#  description      :text
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#  address          :string(255)
#  latitude         :float
#  longitude        :float
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ext_project do
    photo "MyString"
    title "MyString"
    location "MyString"
    funding_goal 1.5
    number_of_donors 1
    executed_at "2013-11-19 18:43:42"
    description "MyText"
    user nil
  end
end
