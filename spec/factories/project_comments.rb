# == Schema Information
#
# Table name: project_comments
#
#  id         :integer          not null, primary key
#  content    :text
#  user_id    :integer
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#  photo      :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project_comment do
    content "MyText"
    user nil
    project nil
  end
end
