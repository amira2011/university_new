class StudentDetail < ApplicationRecord
  belongs_to :student

  validates :address, presence: true
  validates :zip, presence: true
  validates :emergency_contact, presence: true
end
