class Employee < ApplicationRecord
  enum gender: { other: 0, male: 1, female: 2 }

  validates :name, presence: true
  validates :department, presence: true
  validates :payment, presence: true

  def years_worked
    today = Date.today()
    diff_months = (today.year * 12 + today.month) - (joined_date.year * 12 + joined_date.month)
    year, month = diff_months.divmod(12)
    1 + year
  end
end
