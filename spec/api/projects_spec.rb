require 'spec_helper'

describe 'API Project' do
  context 'renders latest public_view projects' do
    it 'empty' do
      get 'api/v1/projects'
      expect(JSON.parse(response.body)).to eq([])
    end

    it 'one project' do
      Timecop.freeze('2013-05-22') do
        @project = Project.create!(
          :title => 'Test', 
          :brief => 'This is a brief to be put here', 
          :description => 'Help me to put something here',
          start_date: Time.parse('2013-05-23'), end_date: Time.parse('2013-05-30'), 
          funding_goal: 3000000, location: 'Ho Chi Minh', user_id: 1
        )
        @project.update_attribute(:status, 'REVIEWED')
        @project.update_attribute(:unlisted, false)
      end
      get 'api/v1/projects'
      expect(JSON.parse(response.body)).to_not eq([])
    end
  end
end