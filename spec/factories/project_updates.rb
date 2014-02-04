# == Schema Information
#
# Table name: project_updates
#
#  id         :integer          not null, primary key
#  content    :text
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#  photo      :string(255)
#  title      :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project_update do
    content "MyText"
    project nil
  end
end
