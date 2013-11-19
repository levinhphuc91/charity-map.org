# == Schema Information
#
# Table name: ext_projects
#
#  id               :integer          not null, primary key
#  photo            :string(255)
#  title            :string(255)
#  location         :string(255)
#  funding_goal     :float
#  number_of_donors :integer
#  executed_at      :datetime
#  description      :text
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#  address          :string(255)
#  latitude         :float
#  longitude        :float
#

require 'spec_helper'

describe ExtProject do
  pending "add some examples to (or delete) #{__FILE__}"
end
