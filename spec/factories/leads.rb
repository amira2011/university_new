FactoryBot.define do
  factory :lead do
    sequence(:id) { |n| n }
    first_name { "John" }
    last_name { "Doe" }
  end
end
