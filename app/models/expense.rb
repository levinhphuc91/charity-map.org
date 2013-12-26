# == Schema Information
#
# Table name: expenses
#
#  id         :integer          not null, primary key
#  category   :string(255)
#  amount     :float
#  project_id :integer
#  in_words   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Expense < ActiveRecord::Base
  belongs_to :project
  attr_accessible :category, :amount, :in_words, :project_id, :created_at
  validates :category, :amount, :in_words, presence: true
  validate :permitted_categories

  private
    def permitted_categories
      errors.add(:category, "should be predefined") if (["OPERATION", "PLATFORM", "PROJECT"].index(self.category) == nil)
    end
end
