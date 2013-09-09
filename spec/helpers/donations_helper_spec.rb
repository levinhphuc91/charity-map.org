require 'spec_helper'

describe DonationsHelper do

  let(:valid_attributes) { { "title" => "MyString", "brief" => "This is a forkingggg Brief", "description" => "My description",
    "start_date" => "2014-05-23", "end_date" => "2014-05-30", "funding_goal" => 3000000,
    "user_id" => 1, "location" => "Ho Chi Minh" } }

  describe "auto_select_project_reward" do
    it "picks the only reward" do
      project = Project.create! valid_attributes
      reward = ProjectReward.create amount: 10000, description: "The Only Reward", project_id: project.id
      helper.auto_select_project_reward(project, 10000).should eq(reward.id)
    end

    it "works with two-reward projects" do
      project = Project.create! valid_attributes
      first_reward = ProjectReward.create amount: 10000, description: "The First Reward", project_id: project.id
      second_reward = ProjectReward.create amount: 99999, description: "The Second Reward", project_id: project.id
      helper.auto_select_project_reward(project, 10000).should eq(first_reward.id)
      helper.auto_select_project_reward(project, 10001).should eq(first_reward.id)
      helper.auto_select_project_reward(project, 99999).should eq(second_reward.id)
      helper.auto_select_project_reward(project, 100000).should eq(second_reward.id)
    end

    it "works with more-than-two-reward projects" do
      project = Project.create! valid_attributes
      first_reward = ProjectReward.create amount: 50000, description: "The First Reward", project_id: project.id
      second_reward = ProjectReward.create amount: 100000, description: "The Second Reward", project_id: project.id
      third_reward = ProjectReward.create amount: 200000, description: "The Third Reward", project_id: project.id
      helper.auto_select_project_reward(project, 49999).should eq(nil)
      helper.auto_select_project_reward(project, 50000).should eq(first_reward.id)
      helper.auto_select_project_reward(project, 110000).should eq(second_reward.id)
      helper.auto_select_project_reward(project, 500000).should eq(third_reward.id)
    end
  end 
end