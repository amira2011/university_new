# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


Course.destroy_all
Student.destroy_all

Course.create!([{
  short_name: "CS111",
  name: "Computer Science",
  desc: "Brief Info About Computer Science"
  
},
{
    short_name: "CS112",
  name: "Data Structure",
  desc: "Brief Info About Data Structure"
},
{
    short_name: "CS113",
    name: "Algoruthm Science",
    desc: "Brief Info About Computer Algorithm"
}])

Student.create!([{
  
  name: "Abid",
  email: "shaikh.abidali@gmail.com",
  password: "password"
},
{
  name: "Demo",
  email: "demo.uni@gmail.com",
  password: "password"
},
 ])
