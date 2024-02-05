require "uri"
require "net/http"
require "json"
require "faker"

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
    puts minus(10, 20)
    puts multiply(10, 20)
    puts hello
  end

  def get_students
    Student.all
  end

  def self.get_git_repo(name)
    arr = Array.new
    uri = URI("https://api.github.com/users/#{name}/repos")
    res = Net::HTTP.get_response(uri)
    repos = res.body if res.is_a?(Net::HTTPSuccess)
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

  def self.seed_leads
    LeadViolation.destroy_all
    LeadVehicle.destroy_all
    LeadDriver.destroy_all
    LeadDetail.destroy_all
    Lead.destroy_all

    100.times do
      lead = Lead.create!(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.email,
        phone: Faker::PhoneNumber.phone_number,
        address: Faker::Address.street_address,
        address2: Faker::Address.secondary_address,
        city: Faker::Address.city,
        state: Faker::Address.state_abbr,
        zip: Faker::Address.zip_code,
      )

      lead_detail = LeadDetail.create!(
        lead: lead,
        home_garage: Faker::Boolean.boolean,
        home_owner: Faker::Boolean.boolean,
        home_length: Faker::Number.between(from: 1000, to: 5000),
        interested_in_home_insurance: Faker::Boolean.boolean,
        interested_in_condo_insurance: Faker::Boolean.boolean,
        interested_in_life_insurance: Faker::Boolean.boolean,
        interested_in_renters_insurance: Faker::Boolean.boolean,
        interested_in_usage_based_policy: Faker::Boolean.boolean,
        currently_insured: Faker::Boolean.boolean,
        current_company: Faker::Company.name,
        current_customer: Faker::Number.between(from: 1, to: 10),
        continuous_coverage: Faker::Number.between(from: 1, to: 5),
        current_policy_expiration_date: Faker::Date.between(from: Date.today, to: 1.year.from_now),
        military_affiliation: Faker::Boolean.boolean,
      )

      num_drivers = Faker::Number.between(from: 1, to: 3)

      num_drivers.times do
        driver = LeadDriver.create!(
          lead: lead,
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          relationship: Faker::Lorem.word,
          gender: Faker::Gender.binary_type,
          marital_status: Faker::Demographic.marital_status,
          birth_date: Faker::Date.between(from: 30.years.ago, to: 18.years.ago),
          first_licensed: Faker::Number.between(from: 18, to: 30),
          education: Faker::Educator.degree,
          credit_rating: Faker::Business.credit_card_type,
          bankruptcy: Faker::Boolean.boolean,
          occupation: Faker::Job.title,
          good_student: Faker::Boolean.boolean,
          license_status: Faker::Lorem.word,
          suspended_reason: Faker::Lorem.word,
          license_state: Faker::Address.state_abbr,
          sr_22: Faker::Boolean.boolean,
        )

        num_vehicles = Faker::Number.between(from: 1, to: 2)

        num_vehicles.times do
          LeadVehicle.create!(
            lead: lead,
            lead_driver: driver,
            year: Faker::Vehicle.year,
            make: Faker::Vehicle.make,
            model: Faker::Vehicle.model,
            submodel: Faker::Vehicle.style,
            vin: Faker::Vehicle.vin,
            alarm: Faker::Boolean.boolean,
            primary_purpose: Faker::Vehicle.car_type,
            average_mileage: Faker::Number.between(from: 5000, to: 20000),
            commute_days_per_week: Faker::Number.between(from: 1, to: 5),
            annual_mileage: Faker::Vehicle.mileage,
            ownership: Faker::Vehicle.license_plate,
            collision: Faker::Vehicle.transmission,
            comprehensive: Faker::Vehicle.fuel_type,
          )
        end

        num_violations = Faker::Number.between(from: 0, to: 2)

        num_violations.times do
          LeadViolation.create!(
            lead: lead,
            lead_driver: driver,
            violation_type: Faker::Lorem.word,
            incident_date: Faker::Date.between(from: 3.years.ago, to: 1.day.ago),
            description: Faker::Lorem.sentence,
            what_damaged: Faker::Lorem.word,
            accident_at_fault: Faker::Boolean.boolean,
            claim_at_fault: Faker::Boolean.boolean,
            amount_paid: Faker::Number.decimal(l_digits: 3, r_digits: 2),
            dui_state: Faker::Address.state_abbr,
          )
        end
      end
    end
    puts "Seeded data successfully!"
  end
end
