# == Schema Information
#
# Table name: gift_cards
#
#  id              :integer          not null, primary key
#  recipient_email :string(255)
#  amount          :float
#  references      :hstore
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe GiftCard do
  pending "add some examples to (or delete) #{__FILE__}"
end
