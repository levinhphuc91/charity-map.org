# == Schema Information
#
# Table name: verifications
#
#  id         :integer          not null, primary key
#  code       :string(255)
#  user_id    :integer
#  channel    :string(255)
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  receipt    :hstore
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :verification do
    user_id 1
    code "11111"
    channel "phone"
    status "UNUSED"
  end
end
