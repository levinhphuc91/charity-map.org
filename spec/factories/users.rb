# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email                 'team@charity-map.org'
    password              'CharityMap@2013'
    password_confirmation 'CharityMap@2013'
  end
end
