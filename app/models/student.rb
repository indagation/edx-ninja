class Student < ActiveRecord::Base
  belongs_to :course
  belongs_to :user
  has_many :submissions
  delegate :username, to: :user
end
