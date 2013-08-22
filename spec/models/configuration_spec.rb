# == Schema Information
#
# Table name: configurations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  value      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Configuration do
  
  it "should check presence of :name" do
    config = Configuration.create
    config.should_not be_valid
  end

  it "should now allow duplicate objects" do
    config = Configuration.create(name: "site_name")
    another_config = Configuration.create(name: "site_name")
    another_config.should_not be_valid
  end

  it "should returns the values of the config simulating a Hash" do
    config = Configuration.create(name: "admin_email", value: "team@charity-map.org")
    Configuration[:admin_email].should eq("team@charity-map.org")
  end

end
