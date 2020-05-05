class Employee < ApplicationRecord
  enum gender: [:male, :female, :other]

  validates :name, presence: true
  validates :department, presence: true
  validates :payment, presence: true
end
