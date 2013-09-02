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

require 'spec_helper'

describe Donation do
  it "should have euid before_validation" do
    donation = Donation.create(user_id: 1, project_id: 1)
    donation.euid.length.should eq(5)
  end
end
