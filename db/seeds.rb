# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'
 
 

   100.times do |i|
      Student.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        age: rand(18..25),
        category: ["open", "obc", "sc", "nt", "st", "other"].sample,
        enrolled: [true, false].sample,
        password: "password"
      )
    end

    100.times do 
      Course.create(
        short_name: Faker::Educator.subject,
        name: Faker::Educator.course_name, 
        desc: "#{Faker::Educator.subject} #{Faker::Educator.course_name}"
      )
    end

    Student.all.each do |student|
      StudentDetail.create(student_id: student.id,
        address: Faker::Address.city,
        zip: Faker::Address.zip,
        emergency_contact: Faker::PhoneNumber.phone_number
      )
     
    end
      
      



      # Randomly Allocate Student to Courses
      # run Util.add_students_to_courses 
      #
 
 

 