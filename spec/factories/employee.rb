FactoryBot.define do
  factory :employee do
    sequence(:name)       { |n| "John Doe #{n}" }
    sequence(:department) { |n| "Department #{n}" }
    payment               { 100000 }
    gender                { :other }
  end
end
