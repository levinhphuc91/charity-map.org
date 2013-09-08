# == Schema Information
#
# Table name: verifications
#
#  id         :integer          not null, primary key
#  code       :string(255)
#  user_id    :integer
#  channel    :string(255)
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Verification do
  pending "add some examples to (or delete) #{__FILE__}"
end
