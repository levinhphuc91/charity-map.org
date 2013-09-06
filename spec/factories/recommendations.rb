# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :recommendation do
    project nil
    user nil
    content "MyText"
  end
end
