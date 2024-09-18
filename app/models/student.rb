class Student < ApplicationRecord
    has_one_attached :profile_picture
    MSUD_EMAIL_REGEX = /\A[\w+\-.]+@msudenver\.edu\z/i
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :major, presence: true
    validates :school_email, presence: true, uniqueness: true, format: {with: MSUD_EMAIL_REGEX, message: "not a valid msu email address"}
    validates :graduation_date, presence: true
end
