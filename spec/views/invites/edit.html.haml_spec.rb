require 'spec_helper'

describe "invites/edit" do
  before(:each) do
    @invite = assign(:invite, stub_model(Invite,
      :name => "MyString",
      :email => "MyString",
      :phone => "MyString"
    ))
  end

  it "renders the edit invite form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", invite_path(@invite), "post" do
      assert_select "input#invite_name[name=?]", "invite[name]"
      assert_select "input#invite_email[name=?]", "invite[email]"
      assert_select "input#invite_phone[name=?]", "invite[phone]"
    end
  end
end
