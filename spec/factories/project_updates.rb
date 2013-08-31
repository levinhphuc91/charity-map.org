# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project_update do
    content "MyText"
    project nil
  end
end
