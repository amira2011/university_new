desc 'Update fees_paid for previously enrolled students'
task :update_fees_paid => :environment do
  Student.where(enrolled: true, fees_paid: nil).find_each do |student|
    student.update_column(:fees_paid, 10000.00)
  end

  puts 'Fees_paid updated for previously enrolled students.'
end
