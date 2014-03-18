# == Schema Information
#
# Table name: outgoing_mail_logs
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  event      :string(255)
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class OutgoingMailLog < ActiveRecord::Base
  attr_accessible :email, :event, :title
  validates :email, :event, :title, presence: true

  def self.sent?(email, event)
    !where(email: email, event: event).empty?
  end
end
