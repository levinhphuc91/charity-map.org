# == Schema Information
#
# Table name: projects
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  description  :text
#  created_at   :datetime
#  updated_at   :datetime
#  start_date   :datetime
#  end_date     :datetime
#  funding_goal :float
#  location     :string(255)
#  thumbnail    :string(255)
#  user_id      :integer
#  status       :string(255)
#

require 'spec_helper'

describe Project do
  
  it "should have a defaulted status before_create" do
    project = Project.create(:title => "Test", :description => "Help me to put something here",
      start_date: Time.parse('2013-05-23'), end_date: Time.parse('2013-05-30'), funding_goal: 3000000,
      location: "Ho Chi Minh", user_id: 1)
    project.status.should eq("DRAFT")
  end
end
