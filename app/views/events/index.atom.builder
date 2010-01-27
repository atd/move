atom_feed('xmlns:app' => 'http://www.w3.org/2007/app',
          :root_url => polymorphic_url([ path_container, Event.new ])) do |feed|

  feed.title(:type => "xhtml") do 
    feed.div(sanitize(title),:xmlns => "http://www.w3.org/1999/xhtml")
  end

  description = path_container && path_container.respond_to?(:description) && path_container.description
  description ||= current_site.description
  feed.subtitle(:type => "xhtml") do
    feed.div(sanitize(description), :xmlns => "http://www.w3.org/1999/xhtml")
  end if description.present? 

  feed.updated(@events.first.updated_at || Time.now)

  @events.each do |event|
    feed.entry(event, :url => polymorphic_url(event)) do |entry|
      render :partial => 'event',
             :object => event,
             :locals => { :entry => entry }
    end
  end
end
