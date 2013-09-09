# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    title "MyString"
    description "MyText"
    brief "This is a short brief"
  end
end
