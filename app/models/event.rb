class Event < ActiveRecord::Base
  include CommonContent

  attr_accessor :start_at_date, :start_at_hour, :end_at_date, :end_at_hour

  has_many :attendances
  has_many :attendees, :through => :attendances, :source => :user

  acts_as_resource 
  acts_as_container
  acts_as_taggable

  validates_presence_of :start_at, :end_at
  validate :end_after_start

  before_validation do |event|
    if event.start_at_date.present?
      event.start_at = Date.strptime(event.start_at_date, '%d/%m/%Y')
      if event.start_at_hour.present?
        event.start_at += ( Time.parse(event.start_at_hour) - Date.today.to_time )
      end
    end

    if event.end_at_date.present?
      event.end_at = Date.strptime(event.end_at_date, '%d/%m/%Y')
      if event.end_at_hour.present?
        event.end_at += ( Time.parse(event.end_at_hour) - Date.today.to_time )
      end
    end
  end

  after_create do |event|
    event.attendees << event.author
  end

  def ics_visibility
    public_read? ? "PUBLIC" : "PRIVATE"
  end

  private

  def end_after_start
    return unless end_at.present? && start_at.present?

    if end_at < start_at
      errors.add(:end_at, I18n.t('event.errors.end_at.after_start_at'))
    end
  end
end
