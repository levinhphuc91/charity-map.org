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
