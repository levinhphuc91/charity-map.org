# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :token do
    value "MyString"
    created_for "MyString"
    parent_id 1
  end
end
