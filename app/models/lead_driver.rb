class LeadDriver < ApplicationRecord
  belongs_to :lead
  has_many :lead_vehicles
  has_many :lead_violations
end
