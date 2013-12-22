# == Schema Information
#
# Table name: project_rewards
#
#  id          :integer          not null, primary key
#  value       :float
#  description :text
#  project_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#  name        :string(255)
#  photo       :string(255)
#  quantity    :integer
#

require 'spec_helper'

describe ProjectReward do
end
