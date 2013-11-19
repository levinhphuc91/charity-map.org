# == Schema Information
#
# Table name: ext_donations
#
#  id                :integer          not null, primary key
#  project_id        :integer
#  amount            :float
#  note              :text
#  collection_method :string(255)
#  donor             :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  collection_time   :datetime
#

require 'spec_helper'

describe ExtDonation do
  pending "add some examples to (or delete) #{__FILE__}"
end
