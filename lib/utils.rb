

require 'uri'
require 'net/http'
require 'json'

class Utils

    include Math1 
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

    end

    def get_students
        Student.all
    end


    def self.get_git_repo(name)

        arr =Array.new
        uri = URI('https://api.github.com/users/amira2011/repos')
        res = Net::HTTP.get_response(uri)
        repos= res.body if res.is_a?(Net::HTTPSuccess)
        data = JSON.parse(repos)
        data.each do |repo| 
            arr.push(repo["full_name"])
        end

        arr


    end

     
end


