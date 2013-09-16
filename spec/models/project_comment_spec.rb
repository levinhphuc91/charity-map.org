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

require 'spec_helper'

describe ProjectComment do
end
