class Task < ActiveRecord::Base
  include CommonContent

  acts_as_resource 

  validates_presence_of :title
end
