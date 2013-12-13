# == Schema Information
#
# Table name: invites
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  phone      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  project_id :integer
#  status     :string(255)
#

require 'spec_helper'

describe Invite do
  pending "add some examples to (or delete) #{__FILE__}"
end
