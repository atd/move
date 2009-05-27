entry.title(:type => "xhtml") do 
  entry.div(sanitize(audio.title), :xmlns => "http://www.w3.org/1999/xhtml")
end

entry.summary(:type => "xhtml") do
  entry.div(sanitize(audio.description), :xmlns => "http://www.w3.org/1999/xhtml")
end if audio.description.present?

entry.tag!("app:edited", audio.updated_at.xmlschema)

entry.link(:rel => 'edit', :href => polymorphic_url([ audio.container, audio ], :format => :atom ))
  
url_args = ( audio.respond_to?(:container) && audio.container ? [ audio.container, audio ] : audio )

options = {}
options[:src], options[:type] = ( audio.format ?
  [ polymorphic_url(url_args, :format => audio.format), audio.mime_type.to_s ] :
  [ polymorphic_url(url_args), 'text/html' ] )

entry.content(options)
