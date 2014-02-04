# == Schema Information
#
# Table name: projects
#
#  id                   :integer          not null, primary key
#  title                :string(255)
#  description          :text
#  created_at           :datetime
#  updated_at           :datetime
#  start_date           :datetime
#  end_date             :datetime
#  funding_goal         :float
#  location             :string(255)
#  photo                :string(255)
#  user_id              :integer
#  status               :string(255)
#  slug                 :string(255)
#  brief                :text
#  video                :string(255)
#  unlisted             :boolean
#  address              :string(255)
#  latitude             :float
#  longitude            :float
#  invite_email_content :text
#  invite_sms_content   :string(255)
#  short_code           :string(255)
#  bank_info            :text
#  item_based           :boolean
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    title "MyString"
    description "MyText"
    brief "This is a short brief"
  end
end
