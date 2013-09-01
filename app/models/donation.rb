# == Schema Information
#
# Table name: donations
#
#  id                :integer          not null, primary key
#  euid              :string(255)
#  status            :string(255)
#  user_id           :integer
#  amount            :float
#  note              :text
#  collection_method :string(255)
#  project_reward_id :integer
#  project_id        :integer
#  created_at        :datetime
#  updated_at        :datetime
#

class Donation < ActiveRecord::Base
  attr_accessible :euid, :status, :user_id, :amount, :note, :collection_method, :project_reward_id, :project_id
  belongs_to :user
  belongs_to :project
  belongs_to :project_reward
end
