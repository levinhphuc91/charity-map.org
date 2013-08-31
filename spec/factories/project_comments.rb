# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project_comment do
    content "MyText"
    user nil
    project nil
  end
end
