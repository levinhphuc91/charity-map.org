# == Schema Information
#
# Table name: tokens
#
#  id              :integer          not null, primary key
#  value           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  ext_donation_id :integer
#

require 'spec_helper'

describe Token do
  pending "add some examples to (or delete) #{__FILE__}"
end
