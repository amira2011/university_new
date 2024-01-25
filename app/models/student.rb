class Student < ApplicationRecord
    before_save { self.email = email.downcase }

    VALID_CATEGORIES = ["open", "obc", "sc", "nt", "st", "other"]
    validates :category, inclusion: { in: VALID_CATEGORIES, message: "Invalid category" }

    validates :name, presence: true, length: {minimum: 4, maximum:50 }
     
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 105 },
              uniqueness: { case_sensitive: false },
              format: { with: VALID_EMAIL_REGEX }

    has_secure_password          

    has_many :student_courses
    has_many :courses , :through => :student_courses

    def self.search_student(args)
        begin
            arguments = JSON.parse(args)
            puts "JSON arguments: #{arguments}"
            
           
            
          rescue JSON::ParserError => e
            puts "Error parsing JSON: #{e.message}"
          end

    end
end
