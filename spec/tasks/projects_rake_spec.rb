require 'spec_helper'
require 'rake'
require 'timecop'

describe 'foo namespace rake task' do
  before :all do
    Rake.application.rake_require "tasks/projects"
    Rake::Task.define_task(:environment)
  end

  describe 'foo:bar' do

    let :run_rake_task do
      Rake::Task["project:change_project_status_to_finished_after_funding_dur"].reenable
      Rake.application.invoke_task "project:change_project_status_to_finished_after_funding_dur"
    end

    it "should bake a bar" do
      @project = Project.create(:title => "Test", :brief => "This is a brief to be put here", :description => "Help me to put something here",
      start_date: Time.parse('2013-05-23'), end_date: Time.parse('2013-05-30'), funding_goal: 3000000,
      location: "Ho Chi Minh", user_id: 1)
      Timecop.freeze(@project.end_date + 1.day) do
        expect{
          run_rake_task
          @project.reload
        }.to change{@project.status}.from("DRAFT").to("FINISHED")
      end
    end

  end
end