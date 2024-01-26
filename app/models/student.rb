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

    def self.get_students(args)
        begin
            args = JSON.parse(args)
            valid_keys = args.select { |key, _| Student.column_names.map(&:to_sym).include?(key.to_sym) }
            conditions = valid_keys.map { |key, value| "#{key} LIKE '%#{value}%'" }.join(' OR ')
            @search_results = Student.where(conditions)
            return @search_results
        rescue JSON::ParserError => e
            puts "Error parsing JSON in Get Student : #{e.message}"
            Student.where("lower(name) LIKE ? OR lower(email) LIKE ? OR lower(category) LIKE ?  OR lower(age) LIKE ?", "#{args.downcase}%", "#{args.downcase}%" ,"#{args.downcase}%", "#{args.downcase}%" )
        end

    end

    def self.search_student(input)
        if input.is_a?(Hash)
            json_output = input.to_json
            self.get_students(json_output)
          
        elsif input.is_a?(String)
            begin
            input  = JSON.parse(input)
            input = input.to_json
            self.get_students(input)
            rescue JSON::ParserError => e
              puts "Error parsing JSON in Seach: #{e.message}"
              input =  input.split(/[,:&=]/).map(&:strip).map(&:downcase)
              students = Student.where("lower(name) IN (?) OR lower(email) IN (?) OR lower(category) IN (?) OR age IN (?) OR enrolled IN (?)", input, input, input, input, input)
            end
        elsif input.is_a?(Array)
            input = input.map(&:downcase)
            students = Student.where("lower(name) IN (?) OR lower(email) IN (?) OR lower(category) IN (?) OR age IN (?) OR enrolled IN (?)", input, input, input, input, input)
        elsif input.is_a?(JSON)
            self.get_students(input)
        else
            return "Input is of unknown type"
        end
      end


      def self.get_students_by_course(input)
        begin
            result=[]
            input = JSON.parse(input)
            valid_keys = input.select { |key, _| Course.column_names.map(&:to_sym).include?(key.to_sym) }
            conditions = valid_keys.map { |key, value| "#{key} like '%#{value}%'" }.join(' OR ')
            courses = Course.where(conditions)
            courses.each do |course|
                enrolled_students = course.students.includes(:student_detail)
                enrolled_students.each do |student|
                    record = {
                        course: course,
                        student: student,
                        student_detail: student.student_detail
                    }
                    result << record
                end
            end
            return result
        rescue JSON::ParserError => e
            puts "Error parsing JSON in Get Student : #{e.message}"
            
        end
    end


    def self.get_students_by_details(input)
        result =[]
        begin
            if input.is_a?(Hash)
                input = input.to_json
            end
            input = JSON.parse(input)
            valid_keys = input.select { |key, _| StudentDetail.column_names.map(&:to_sym).include?(key.to_sym) }
            conditions = valid_keys.map { | key , value | "#{key} like '%#{value}%'"}.join(' OR ') 
            student_details = StudentDetail.where(conditions).includes(student: :courses)
            student_details.each do |student_detail|
                student = student_detail.student
                record = {
                  student: student,
                  student_detail: student_detail,
                  courses: student.courses
                }
                result << record
              end
            return result
        rescue JSON::ParserError => e
            puts "Error Parsing JSON #{e.message}"
        end
    end
    

    def self.print_record(result)
        result.each do |record|
            puts "Student Name: #{record[:student].name}"
            puts "Student Email: #{record[:student].email}"
            puts "Address: #{record[:student_detail].address}"
            puts "Zip: #{record[:student_detail].zip}"
            puts "Emergency Contact: #{record[:student_detail].emergency_contact}"
            # Display courses associated with the student
            record[:courses].each do |course|
              puts "Enrolled in Course: #{course.name}"
            end
            puts "\n"
          end
    end


end
