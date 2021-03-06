entry.title(:type => "xhtml") do 
  entry.div(sanitize(photo.title), :xmlns => "http://www.w3.org/1999/xhtml")
end

entry.summary(:type => "xhtml") do
  entry.div(sanitize(photo.description), :xmlns => "http://www.w3.org/1999/xhtml")
end if photo.description.present?

entry.tag!("app:edited", photo.updated_at.xmlschema)

entry.link(:rel => 'edit', :href => polymorphic_url([ photo.container, photo ], :format => :atom ))

atom_entry_author(entry, photo)
  
url_args = ( photo.respond_to?(:container) && photo.container ? [ photo.container, photo ] : photo )

options = {}
options[:src], options[:type] = ( photo.format ?
  [ polymorphic_url(url_args, :format => photo.format), photo.mime_type.to_s ] :
  [ polymorphic_url(url_args), 'text/html' ] )

entry.content(options)
