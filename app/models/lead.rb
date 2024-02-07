class Lead < ApplicationRecord
  has_one :lead_detail, dependent: :destroy
  has_many :lead_vehicles, dependent: :destroy
  has_many :lead_drivers, dependent: :destroy
  has_many :lead_violations, dependent: :destroy

  def contact
    "#{first_name} #{last_name}"
  end
end
