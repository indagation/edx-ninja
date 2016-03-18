class Course < ActiveRecord::Base
  has_many :graders
  has_many :students
  has_many :assignments
  has_many :submissions, through: :students
end
