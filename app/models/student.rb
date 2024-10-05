class Student < ApplicationRecord
    MSUD_EMAIL_REGEX = /\A[\w+\-.]+@msudenver\.edu\z/i
    VALID_MAJORS = ["Computer Science BS", "Cybersecurity Major", "Computer Information Systems BS", "Data Science and Machine Learning Major"]


    has_one_attached :profile_picture
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :major, presence: true, inclusion {in VALID_MAJORS, message: "%{value} is not a vaild major"}
    validates :school_email, presence: true, uniqueness: true, format: {with: MSUD_EMAIL_REGEX, message: "not a valid msu email address"}
    validates :graduation_date, presence: true

    def display_image
        profile_picture.variant(resize_to_limit: [300, 300]).processed
    end
end
