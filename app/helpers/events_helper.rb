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
end
