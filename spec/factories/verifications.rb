# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :verification do
    user_id 1
    code "11111"
    channel "phone"
    status "UNUSED"
  end
end