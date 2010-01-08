class Attendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  acts_as_resource
  acts_as_content :reflection => :event
end
