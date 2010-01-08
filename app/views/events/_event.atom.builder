entry.title(:type => "xhtml") do 
  entry.div(sanitize(event.title), :xmlns => "http://www.w3.org/1999/xhtml")
end

entry.summary(:type => "xhtml") do
  entry.div(sanitize(event.description), :xmlns => "http://www.w3.org/1999/xhtml")
end if event.respond_to?(:description.) && event.description.present?

entry.tag!("app:edited", event.updated_at.xmlschema)

entry.link(:rel => 'edit', :href => polymorphic_url(event, :format => :atom))
  
options = {}
options[:src], options[:type] = ( event.format ?
  [ polymorphic_url(event, :format => event.format), event.mime_type.to_s ] :
  [ polymorphic_url(event), 'text/html' ] )

entry.content(options)
