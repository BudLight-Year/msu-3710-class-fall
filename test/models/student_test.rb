require "test_helper"

class StudentTest < ActiveSupport::TestCase
  fixtures :students
  # US1 tests
  test "should raise error when saving student without first name" do
    assert_raises ActiveRecord::RecordInvalid do
        Student.create!(last_name: "Schwemby", email: "test@msudenver.edu", major: "CS", graduation_date: "2024-12-16" )
    end
  end

  test "should raise error when saving student without last name" do
    assert_raises ActiveRecord::RecordInvalid do
      Student.create!(first_name: "Eric", email: "test@msudenver.edu", major: "CS", graduation_date: "2024-12-16")
    end
  end

  test "should raise error when saving student without email" do
    assert_raises ActiveRecord::RecordInvalid do
      Student.create!(first_name: "Eric", last_name: "Schwemby", major: "CS", graduation_date: "2024-12-16")
    end
  end

  test "should raise error when saving student without major" do
    assert_raises ActiveRecord::RecordInvalid do
      Student.create!(first_name: "Eric", last_name: "Schwemby", email: "test@msudenver.edu", graduation_date: "2024-12-16")
    end
  end

  test "should not raise error when saving student with valid data" do
    assert_nothing_raised do
      Student.create!(first_name: "Eric", last_name: "Schwemby", email: "test@msudenver.edu", major: "CS", graduation_date: "2024-12-16")
    end
  end

  test "should display error when student with no email is submitted" do
    student = Student.create(first_name: "Eric", last_name: "Schwemby", major: "CS", graduation_date: "2024-12-16")
    assert_includes student.errors[:email], "can't be blank"  
  end


  # US2 tests
  test "should raise error when student with duplicate email is submitted" do
    students(:one)
    assert_raises ActiveRecord::RecordInvalid do
      Student.create!(first_name: "Eric", last_name: "Schwemby", email: "pparker@msudenver.edu", major: "CS", graduation_date: "2024-12-16")
    end
  end

  test "should display error when student with duplicate email is submitted" do
    students(:one)
    student = Student.create(first_name: "Eric", last_name: "Schwemby", email: "pparker@msudenver.edu", major: "CS", graduation_date: "2024-12-16")
    assert_includes student.errors[:email], "has already been taken"
  end

  test "should raise error when student with improper email format is submitted" do
    assert_raises ActiveRecord::RecordInvalid do
      Student.create!(first_name: "Eric", last_name: "Schwemby", email: "ericemail.com", major: "CS", graduation_date: "2024-12-16")
    end
  end

  test "should raise error when student with non musenver.edu email is submitted" do
    assert_raises ActiveRecord::RecordInvalid do
      Student.create!(first_name: "Eric", last_name: "Schwemby", email: "ericemail@gmail.com", major: "CS", graduation_date: "2024-12-16")
    end
  end

  test "should display error when student with invalid email format is submitted" do
    student = Student.create(first_name: "Eric", last_name: "Schwemby", email: "ericemail.com", major: "CS", graduation_date: "2024-12-16")
    assert_includes student.errors[:email], "not a valid msu email address"
  end

  test "should not save student with improperly formatted email" do
    student = Student.create(first_name: "Eric", last_name: "Schwemby", email: "ericemail.com", major: "CS", graduation_date: "2024-12-16")
    assert_not student.save
  end

  # US3 tests

  test "should attach profile picture" do
    student = Student.new(first_name: "Eric", last_name: "Schwemby", email: "eric@msudenver.edu", major: "CS", graduation_date: "2024-12-16")
    student.profile_picture.attach(io: File.open(Rails.root.join('test', 'fixtures', 'files', 'profile.png')), filename: 'profile.png', content_type: 'image/png')

    assert student.profile_picture.attached?, "Profile picture should be attached"
  end

end

class StudentsIntegrationTest < ActionDispatch::IntegrationTest

  test "should display profile picture from fixture" do
    student = students(:one)
    get student_path(student)
    assert_response :success
    assert_select 'img[src*="profile.png"]', "Profile picture should be displayed"
  end
  
end



