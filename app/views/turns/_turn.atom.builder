entry.title(:type => "xhtml") do 
  entry.div(sanitize(turn.title), :xmlns => "http://www.w3.org/1999/xhtml")
end

entry.summary(:type => "xhtml") do
  entry.div(sanitize(turn.description), :xmlns => "http://www.w3.org/1999/xhtml")
end if turn.description.present?

entry.tag!("app:edited", turn.updated_at.xmlschema)

entry.link(:rel => 'edit', :href => polymorphic_url([ turn.container, turn], :format => :atom ]))
  
url_args = ( turn.respond_to?(:container) && turn.container ? [ turn.container, turn ] : turn )

options = {}
options[:src], options[:type] = ( turn.format ?
  [ polymorphic_url(url_args, :format => turn.format), turn.mime_type.to_s ] :
  [ polymorphic_url(url_args), 'text/html' ] )

entry.content(options)
