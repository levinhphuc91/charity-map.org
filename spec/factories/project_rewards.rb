# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project_reward do
    amount 1.5
    description "MyText"
    project nil
  end
end
