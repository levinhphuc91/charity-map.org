# == Schema Information
#
# Table name: redirect_tokens
#
#  id                  :integer          not null, primary key
#  value               :string(255)
#  redirect_class_name :string(255)
#  redirect_class_id   :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  extra_params        :string(255)
#

require 'spec_helper'

describe RedirectToken do
  pending "add some examples to (or delete) #{__FILE__}"
end
