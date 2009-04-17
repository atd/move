entry.title(:type => "xhtml") do 
  entry.div(sanitize(audio.title), :xmlns => "http://www.w3.org/1999/xhtml")
end

entry.summary(:type => "xhtml") do
  entry.div(sanitize(audio.description), :xmlns => "http://www.w3.org/1999/xhtml")
end if audio.description.present?

entry.tag!("app:edited", audio.updated_at.xmlschema)

entry.link(:rel => 'edit', :href => formatted_polymorphic_url([ audio.container, audio, :atom ]))
  
#FIXME: Rails 2.3 use new object try
url_args = ( audio.respond_to?(:container) && audio.container ? [ audio.container, audio ] : audio )

options = {}
options[:src], options[:type] = ( audio.format ?
  [ formatted_polymorphic_url(url_args + Array(audio.format)), audio.mime_type.to_s ] :
  [ polymorphic_url(url_args), 'text/html' ] )

entry.content(options)
