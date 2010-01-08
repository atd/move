class Event < ActiveRecord::Base
  include CommonContent

  has_many :attendances
  has_many :attendees, :through => :attendances, :source => :user

  acts_as_resource 
  acts_as_container
  acts_as_taggable

  validates_presence_of :start_at, :end_at

  after_create do |event|
    event.attendees << event.author
  end

  def ics_visibility
    public_read? ? "PUBLIC" : "PRIVATE"
  end
end
