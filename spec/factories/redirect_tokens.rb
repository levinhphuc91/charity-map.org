# == Schema Information
#
# Table name: redirect_tokens
#
#  id                  :integer          not null, primary key
#  value               :string(255)
#  redirect_class_name :string(255)
#  redirect_class_id   :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  extra_params        :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :redirect_token do
    value "MyString"
    to_model "MyString"
    to_id "MyString"
  end
end
