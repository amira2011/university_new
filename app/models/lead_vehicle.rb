class LeadVehicle < ApplicationRecord
  belongs_to :lead
  belongs_to :lead_driver
end
