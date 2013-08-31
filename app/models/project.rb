# == Schema Information
#
# Table name: projects
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  description  :text
#  created_at   :datetime
#  updated_at   :datetime
#  start_date   :datetime
#  end_date     :datetime
#  funding_goal :float
#  location     :string(255)
#  thumbnail    :string(255)
#  user_id      :integer
#  status       :string(255)
#

class Project < ActiveRecord::Base

  has_many :project_rewards
  has_many :project_updates
  has_many :project_comments
  has_many :donations
end
