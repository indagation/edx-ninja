class Staff < ActiveRecord::Base
  belongs_to :course
  belongs_to :user
  delegate :username, to: :user, allow_nil: true
end
