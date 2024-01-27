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
    has_one :student_detail
    has_many :student_courses
    has_many :courses , :through => :student_courses

   
    def self.get_students(input)
        begin
            if input.is_a?(Hash)
                input = input.to_json
            end
            input = JSON.parse(input)
            course_conditions = build_conditions(input, Course)
            student_detail_conditions = build_conditions(input, StudentDetail)
            student_conditions = build_conditions(input, Student)
            students = Student.left_joins(:student_detail, :courses)
            .where("#{course_conditions} OR #{student_detail_conditions} OR #{student_conditions}").distinct
            return students
        rescue JSON::ParserError => e
            puts "Error Parsing JSON #{e.message}"
        end
    end


    def self.get_students_hash(input)
        students = get_students(input)
        result = {}
        students.each do |student|
            courses = student.courses.distinct.pluck(:id) # Assuming 'id' is the attribute you want to retrieve
            result[student.id.to_s] = { "courses" => courses }
        end
        return result
    end


    def self.build_conditions(input, model)
        keys = input.select { |key, _| model.column_names.map(&:to_sym).include?(key.to_sym) }
        conditions = keys.map { |key, value| "#{key} like '%#{value}%'" }.join(' OR ')
    end

end
