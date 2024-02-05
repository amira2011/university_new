module Math1
  def sum(a, b)
    return a + b
  end

  def minus(a, b)
    return a - b
  end

  def multiply(a, b)
    return a * b
  end

  def self.get_student()
    Student.first
  end
end
