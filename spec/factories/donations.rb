# == Schema Information
#
# Table name: donations
#
#  id                      :integer          not null, primary key
#  euid                    :string(255)
#  status                  :string(255)
#  user_id                 :integer
#  amount                  :float
#  note                    :text
#  collection_method       :string(255)
#  project_reward_id       :integer
#  project_id              :integer
#  created_at              :datetime
#  updated_at              :datetime
#  project_reward_quantity :integer
#  anon                    :boolean
#  admin_note              :string(255)
#

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
