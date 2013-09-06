# == Schema Information
#
# Table name: recommendations
#
#  id         :integer          not null, primary key
#  project_id :integer
#  user_id    :integer
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Recommendation do
  pending "add some examples to (or delete) #{__FILE__}"
end
