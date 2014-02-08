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

class GiftCard < ActiveRecord::Base
end
