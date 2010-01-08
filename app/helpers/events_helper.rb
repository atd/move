module EventsHelper
  def events_list(events = @events)
    upcoming_event_list(events) +
    past_event_list(events)
  end

  def upcoming_event_list(events)
    upcoming_events = events.select{ |e| e.start_at > Time.now }.sort{ |x, y| x.start_at <=> y.start_at}
    return "" if upcoming_events.blank?

    returning "<h2>#{ t('event.upcoming.other') }</h2>" do |html|
      upcoming_events.each do |e|
        html << render(:partial => 'index_event', :object => e)
      end
    end
  end

  def past_event_list(events)
    past_events = events.select{ |e| e.start_at < Time.now }.sort{ |x, y| y.start_at <=> x.start_at}
    return "" if past_events.blank?

    returning "<h2>#{ t('event.past.other') }</h2>" do |html|
      past_events.each do |e|
        html << render(:partial => 'index_event', :object => e)
      end
    end
  end

  def build_ics(events)
    cal = Vpim::Icalendar.create2

    events.each do |e|
      cal.add_event do |ce|
        ce.dtstart       e.start_at
        ce.dtend         e.end_at
        ce.summary       e.title
        if e.description.present?
          ce.description   e.description
        end
        ce.categories    e.tags.map(&:name)
        ce.url           polymorphic_url(e)
        ce.access_class  e.ics_visibility

        ce.created       e.created_at
        ce.lastmod       e.updated_at

        e.attendees.each do |a|
          ca          = Vpim::Icalendar::Address.new
          ca.cn       = a.name
          ca.uri      = polymorphic_url(a)
          ca.partstat = "ACCEPTED"

          ce.add_attendee ca
        end
      end
    end

    cal.encode
  end
end
