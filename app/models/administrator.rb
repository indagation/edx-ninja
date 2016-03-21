class Administrator < ActiveRecord::Base
  belongs_to :course
  belongs_to :user
  delegate :username, :email, to: :user, allow_nil: true
end
