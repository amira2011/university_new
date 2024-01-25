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

    def self.get_students(args)
        begin
            puts args.class
            args = JSON.parse(args)
            puts "JSON arguments: #{args.keys}"
            puts "#{Student.column_names}"
            valid_keys = args.select { |key, _| Student.column_names.map(&:to_sym).include?(key.to_sym) }
            puts "#{valid_keys}"
            conditions = valid_keys.map { |key, value| "#{key} = '#{value}'" }.join(' OR ')
            @search_results = Student.where(conditions)
            return @search_results
        rescue JSON::ParserError => e
            puts "Error parsing JSON in Get Student : #{e.message}"
            Student.where("lower(name) LIKE ? OR lower(email) LIKE ? OR lower(category) LIKE ?  OR lower(age) LIKE ?", "#{args.downcase}%", "#{args.downcase}%" ,"#{args.downcase}%", "#{args.downcase}%" )
        end

    end

    def self.search_student(input)
        if input.is_a?(Hash)
            puts "Input is a Hash"
            json_output = input.to_json
            self.get_students(json_output)
          
        elsif input.is_a?(String)
            puts "Input is a String"
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
            puts "Input is an Array"
            input = input.map(&:downcase)
            students = Student.where("lower(name) IN (?) OR lower(email) IN (?) OR lower(category) IN (?) OR age IN (?) OR enrolled IN (?)", input, input, input, input, input)
        elsif input.is_a?(JSON)
            self.get_students(input)
        else
            return "Input is of unknown type"
        end
      end



end
