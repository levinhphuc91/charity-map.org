# == Schema Information
#
# Table name: organization_lists
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  email                 :string(255)
#  website               :string(255)
#  facebook              :string(255)
#  address               :text
#  legal_entity          :string(255)
#  geographical_area     :string(255)
#  category              :hstore
#  year_of_establishment :string(255)
#  key_contact           :text
#  bank_account          :text
#  created_at            :datetime
#  updated_at            :datetime
#

class OrganizationList < ActiveRecord::Base
  attr_accessible :name, :email, :address, :key_contact, :bank_account,
    :website, :category, :legal_entity, :facebook, :geographical_area, :year_of_establishment

  has_defaults legal_entity: "false"
  validates :email, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :email, uniqueness: true
end