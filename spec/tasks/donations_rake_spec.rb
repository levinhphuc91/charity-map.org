require 'spec_helper'
require 'rake'
require 'timecop'
require 'database_cleaner'

describe 'donations:' do
  before :all do
    Rake.application.rake_require "tasks/donations"
    Rake::Task.define_task(:environment)
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
    @user = User.create!(email: "donor@gmail.com", 
      password: "secretpass", password_confirmation: "secretpass")
    Timecop.freeze("2013-05-22") do
      @project = Project.create!(:title => "Test", 
      :brief => "This is a brief to be put here", 
      :description => "Help me to put something here",
      start_date: Time.parse('2013-05-23'), end_date: Time.parse('2013-05-30'), 
      funding_goal: 3000000, location: "Ho Chi Minh", user_id: @user.id)
    end
    @project.project_rewards.create!(value: 10000, description: "Initial reward")
    @donation = @project.donations.create!(user_id: @user.id, amount: 100000,
        collection_method: "BANK_TRANSFER")
  end

  describe 'bank_transfer_reminder' do
    let :run_rake_task do
      Rake::Task["donations:bank_transfer_reminder"].reenable
      Rake.application.invoke_task "donations:bank_transfer_reminder"
    end

    it "should send reminder after 5 days" do
      Timecop.freeze(@donation.created_at + 5.days + 12.hours) do
        run_rake_task
        ActionMailer::Base.deliveries.last.to.should == ["donor@gmail.com"]
      end
    end

    it "should send reminder after 10 days" do
      Timecop.freeze(@donation.created_at + 10.days) do
        run_rake_task
        ActionMailer::Base.deliveries.last.to.should == ["donor@gmail.com"]
      end
    end
  end

  describe 'bank_transfer_mark_as_failed' do
    let :run_rake_task do
      Rake::Task["donations:bank_transfer_mark_as_failed"].reenable
      Rake.application.invoke_task "donations:bank_transfer_mark_as_failed"
    end

    it "mark #failed for bank-transfer donations beyond 15 days" do
      Timecop.freeze(@donation.created_at + 15.days) do
        expect{
          run_rake_task
          @donation.reload
        }.to change{@donation.status}.from("PENDING").to("FAILED")
      end
    end
  end
end