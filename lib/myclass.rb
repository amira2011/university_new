class MyClass
  private

  def abid()
    puts "Hello, abid"
  end

  def yogesh()
    puts "Hello, yogesh"
  end

  def test()
    puts "Hello, User"
  end

  def default(name)
    puts "Method not found for #{name}"
  end

  def try_dynamic(name)
    if respond_to?(name)
      send(name)
      public_send(name)
      self.method(:name).call
    else
      default(name)
    end
  end
end
