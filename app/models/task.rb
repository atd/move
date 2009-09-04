class Task < ActiveRecord::Base
  include CommonContent

  acts_as_resource 
  acts_as_container :contents => [ :turns ]

  has_many :turns, :order => 'position'

  validates_presence_of :title
end
