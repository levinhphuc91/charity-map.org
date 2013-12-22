# == Schema Information
#
# Table name: donations
#
#  id                      :integer          not null, primary key
#  euid                    :string(255)
#  status                  :string(255)
#  user_id                 :integer
#  amount                  :float
#  note                    :text
#  collection_method       :string(255)
#  project_reward_id       :integer
#  project_id              :integer
#  created_at              :datetime
#  updated_at              :datetime
#  project_reward_quantity :integer
#

require 'spec_helper'

describe Donation do
  it "should have euid before_validation" do
    project = Project.create(:title => "Test", :brief => "People have to enter a brief intro to proceed", :description => "Help me to put something here",
      start_date: '2014-05-23', end_date: '2014-05-30', funding_goal: 3000000,
      location: "Ho Chi Minh", user_id: 1)
    project_reward = ProjectReward.create(:amount => "10000", :description => "Tada", :project_id => project.id)
    donation = Donation.create(user_id: 1, project_id: project.id)
    donation.euid.length.should eq(5)
  end
end
