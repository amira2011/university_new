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

    def self.search_all(args)
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
            puts "Error parsing JSON: #{e.message}"
        end

    end

    def self.search_student(input)
        if input.is_a?(Hash)
          puts "Input is a Hash"
          json_output = input.to_json
          self.search_all(json_output)
          
        elsif input.is_a?(String)
            puts "Input is a String"
            begin
            input  = JSON.parse(input)
            input = input.to_json
            self.search_all(input)
            rescue JSON::ParserError => e
                puts "Error parsing JSON: #{e.message}"
            end

          
        elsif input.is_a?(Array)
          return "Input is an Array"
        elsif input.is_a?(JSON)
            self.search_student(input)
        else
          return "Input is of unknown type"
        end
      end



end
