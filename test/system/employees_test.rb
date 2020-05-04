require "application_system_test_case"

class EmployeesTest < ApplicationSystemTestCase
  setup do
    @employee = employees(:one)
  end

  test "visiting the index" do
    visit employees_url
    assert_selector "h1", text: "Employees"
  end

  test "creating a Employee" do
    visit employees_url
    click_on "New Employee"

    fill_in "Birth", with: @employee.birth
    fill_in "Department", with: @employee.department
    fill_in "Gender", with: @employee.gender
    fill_in "Joined date", with: @employee.joined_date
    fill_in "Name", with: @employee.name
    fill_in "Note", with: @employee.note
    fill_in "Payment", with: @employee.payment
    click_on "Create Employee"

    assert_text "Employee was successfully created"
    click_on "Back"
  end

  test "updating a Employee" do
    visit employees_url
    click_on "Edit", match: :first

    fill_in "Birth", with: @employee.birth
    fill_in "Department", with: @employee.department
    fill_in "Gender", with: @employee.gender
    fill_in "Joined date", with: @employee.joined_date
    fill_in "Name", with: @employee.name
    fill_in "Note", with: @employee.note
    fill_in "Payment", with: @employee.payment
    click_on "Update Employee"

    assert_text "Employee was successfully updated"
    click_on "Back"
  end

  test "destroying a Employee" do
    visit employees_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Employee was successfully destroyed"
  end
end
