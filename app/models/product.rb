class Product < ApplicationRecord
  self.table_name = "my_products"
  # after_initialize :do_something

  before_validation do
    puts "I am inside before validation"
  end

  def do_something
    puts "You have initialized an object!"
  end

  after_validation do
    puts "I am inside after validation"
  end

  before_save do
    puts "I am inside before save"
  end

  around_save do
    puts "I am inside around save"
    yield
  end

=begin


 before_create do
    puts "I am inside before create"
  end
   
  

  around_create do
    puts "I am inside around create"
  end

  after_create do
    puts "I am inside after create"
  end
  
  after_save do
    puts "I am inside after save"
  end

  after_commit do
    puts "I am inside after commit"
  end
   
  after_rollback do
    puts "I am inside after rollback"
  end
=end
end
