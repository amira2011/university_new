class UpdateFeesPaidJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    enrolled_students = Student.where(enrolled: true, fees_paid: nil)

    enrolled_students.each do |student|
      student.update_column(:fees_paid, 10000.00)
      #puts student.name
    end

    puts 'Fees_paid updated for previously enrolled students.'
    #  UpdateFeesPaidJob.perform_later
  end
end
