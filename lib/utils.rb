

require 'uri'
require 'net/http'
require 'json'

class Utils

    $data = nil
    include Math1
    include InsuranceExchangeIntegration
    @@count = 0
    attr_accessor :first_name, :last_name

    def initialize(first_name, last_name)
        @first_name = first_name
        @last_name = last_name
        @@count += 1
    end

    def name
        puts age
        return "your name is #{@first_name} #{@last_name}"
    end

    def self.get_count
        puts @@count
        puts age
    end

    def age
        return 20
    end

    def self.age
        return 25
    end


    def use_math

       puts minus(10,20)
       puts multiply(10,20)
       puts hello

    end

    def get_students
        Student.all
    end


    def self.get_git_repo(name)

        arr =Array.new
        uri = URI("https://api.github.com/users/#{name}/repos")
        res = Net::HTTP.get_response(uri)
        repos= res.body if res.is_a?(Net::HTTPSuccess)
        if repos
        data = JSON.parse(repos)
        end
        #puts data
        data.each do |repo|
            arr.push(repo["full_name"])
        end

        data


    end

    def self.get_languages(url)
        uri = URI(url)
        res = Net::HTTP.get_response(uri)
        data = res.body if res.is_a?(Net::HTTPSuccess)
        if repos
        jdata = JSON.parse(repos)
        end
    end



    def self.get_uri_data(url)
        begin
          uri = URI(url)
          res = Net::HTTP.get_response(uri)
    
          if res.is_a?(Net::HTTPSuccess)
            repos = res.body
            data = JSON.parse(repos)
          else
            puts "Error: #{res.code} - #{res.message}"
            data = nil
          end
    
        rescue URI::InvalidURIError => e
          puts "Invalid URI: #{e.message}"
          data = nil
        rescue JSON::ParserError => e
          puts "Error parsing JSON: #{e.message}"
          data = nil
        rescue StandardError => e
          puts "An unexpected error occurred: #{e.message}"
          data = nil
        end
    
        data
      end



      def self.check_input_type(input)
        case input
        when Hash
          return "Input is a Hash"
        when String
          return "Input is a String"
        when Array
          return "Input is an Array"
        when JSON
          begin
            JSON.parse(input)
            return "Input is a valid JSON"
          rescue JSON::ParserError
            return "Input is not a valid JSON"
          end
        else
          return "Input is of unknown type"
        end
      end



      def self.add_students_to_courses
        courses = Course.all.to_a
        students = Student.all.to_a
                
        students.each do |student|
          Course.all.sample(20).each do |course|
            StudentCourse.create(course: course, student: student)
          end
        end
      end


      def self.update_fees_paid

        enrolled_students = Student.where(enrolled: true, fees_paid: nil)
        enrolled_students.each do |student|
          student.update_column(:fees_paid, 10000.00)
         
        end
      end



end
