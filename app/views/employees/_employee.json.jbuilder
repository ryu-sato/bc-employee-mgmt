json.extract! employee, :id, :name, :department, :gender, :birth, :joined_date, :payment, :note, :created_at, :updated_at
json.url employee_url(employee, format: :json)
