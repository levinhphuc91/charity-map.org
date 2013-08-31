# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :donation do
    euid "MyString"
    status "MyString"
    user nil
    amount 1.5
    note "MyText"
    collection_method "MyString"
    project_reward nil
    project nil
  end
end
