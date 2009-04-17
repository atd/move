entry.title(:type => "xhtml") do 
  entry.div(sanitize(document.title), :xmlns => "http://www.w3.org/1999/xhtml")
end

entry.summary(:type => "xhtml") do
  entry.div(sanitize(document.description), :xmlns => "http://www.w3.org/1999/xhtml")
end if document.description.present?

entry.tag!("app:edited", document.updated_at.xmlschema)

entry.link(:rel => 'edit', :href => formatted_polymorphic_url([ document.container, document, :atom ]))
  
#FIXME: Rails 2.3 use new object try
url_args = ( document.respond_to?(:container) && document.container ? [ document.container, document ] : document )

options = {}
options[:src], options[:type] = ( document.format ?
  [ formatted_polymorphic_url(url_args + Array(document.format)), document.mime_type.to_s ] :
  [ polymorphic_url(url_args), 'text/html' ] )

entry.content(options)
