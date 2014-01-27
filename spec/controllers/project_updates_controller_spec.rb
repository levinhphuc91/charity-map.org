require 'spec_helper'

describe ProjectUpdatesController do
  integrate_views
  describe "GET 'home'" do
    it "has :vi as default locale" do
      user = User.create(email: "tu@charity-map.org", password: "123456", password_confirmation: "123456")
      project = user.projects.create(:title => "Test", :brief => "This is a brief to be put here", :description => "Help me to put something here",
        start_date: Time.parse('2013-05-23'), end_date: Time.parse('2013-05-30'), funding_goal: 3000000,
        location: "Ho Chi Minh")
      project_reward = project.project_rewards.create(value: 100000, description: "reward description")
      donation = project.donations.create(user_id: user.id, amount: 100000, status: "SUCCESSFUL", collection_method: "BANK_TRANSFER")
      params = {title: "Update Titlte", content: "Update Content", project_id: project.id}
      RedirectToken.any_instance.stubs(:create)
      post :create, params
      # invitation = double('RedirectToken', :accept => true)
      expect(RedirectToken).to have_received(:create)
    end
  end
end