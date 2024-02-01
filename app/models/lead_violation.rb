class LeadViolation < ApplicationRecord
  belongs_to :lead_driver
  belongs_to :lead
end
