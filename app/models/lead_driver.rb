class LeadDriver < ApplicationRecord
  belongs_to :lead
  has_many :lead_vehicles
  has_many :lead_violations

  MARITAL_STATUS_MAPPING = {
    "Happily Married" => "Married",
    "Not Married" => "Single",
    "breakup" => "Separated",
    "dissolution" => "Divorced",
  }

  VALID_MARITAL_STATUS = ["Single", "Married", "Divorced", "Separated", "Widowed", "Domestic Partner", "Unknown"]
  #validates :marital_status, inclusion: { in: VALID_MARITAL_STATUS, message: "Invalid Marital Status" }

  def self.transform_marital_status_for_api(value)
    mapped_value = MARITAL_STATUS_MAPPING[value] || value
    VALID_MARITAL_STATUS.include?(mapped_value) ? mapped_value : "Unknown"
  end
end
