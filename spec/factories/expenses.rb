# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :expense do
    category "MyString"
    amount 1.5
    project nil
    in_words "MyString"
  end
end
