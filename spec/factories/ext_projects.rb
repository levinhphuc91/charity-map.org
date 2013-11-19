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
