class Lead < ApplicationRecord

    has_one :lead_detail
    has_many :lead_vehicles
    has_many :lead_drivers
    has_many :lead_violations

end
