require 'spec_helper'

describe "invites/index" do
  before(:each) do
    assign(:invites, [
      stub_model(Invite,
        :name => "Name",
        :email => "Email",
        :phone => "Phone"
      ),
      stub_model(Invite,
        :name => "Name",
        :email => "Email",
        :phone => "Phone"
      )
    ])
  end

  it "renders a list of invites" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
  end
end
