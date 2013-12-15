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

require 'spec_helper'

describe ProjectUpdate do
end
