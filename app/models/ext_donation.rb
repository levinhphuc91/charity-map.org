# == Schema Information
#
# Table name: ext_donations
#
#  id                :integer          not null, primary key
#  project_id        :integer
#  amount            :float
#  note              :text
#  collection_method :string(255)
#  donor             :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  collection_time   :datetime
#  email             :string(255)
#  phone             :string(255)
#  anon              :boolean
#  status            :string(255)
#

class ExtDonation < ActiveRecord::Base
  default_scope where(:status => "NEW")

  belongs_to :project
  has_one :token
  attr_accessible :donor, :amount, :note, :email, :phone,
    :collection_method, :collection_time, :project_id, :token_id, :anon
  validates :donor, :amount, :collection_time, :project_id, :status, presence: true
  has_defaults anon: false, status: "NEW"

  before_validation :email_provided_not_belongs_to_any_users
  after_create :generate_token

  scope :bank_transfer, -> { where(collection_method: "BANK_TRANSFER") }
  scope :cod, -> { where(collection_method: "COD") }

  def generate_token
    self.create_token
  end

  def name
    donor || email.split("@").first
  end

  def email_provided_not_belongs_to_any_users
    if email
      @user = User.find_by(email: email)
      errors.add(:email, "đã được đăng ký thành viên trên Charity Map. Vui lòng liên hệ MTQ để tiến hành ủng hộ qua hệ thống.") if @user
    end
  end
end