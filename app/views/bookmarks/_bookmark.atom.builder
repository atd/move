entry.title(:type => "xhtml") do 
  entry.div(sanitize(bookmark.title), :xmlns => "http://www.w3.org/1999/xhtml")
end

entry.summary(:type => "xhtml") do
  entry.div(sanitize(bookmark.description), :xmlns => "http://www.w3.org/1999/xhtml")
end if bookmark.description.present?

entry.tag!("app:edited", bookmark.updated_at.xmlschema)

entry.link(:rel => 'edit', :href => formatted_polymorphic_url([ bookmark.container, bookmark, :atom ]))
  
entry.content(:type => 'xhtml') do |xhtml|
  xhtml << link_to(sanitize(bookmark.title), sanitize(bookmark.uri.to_s))
end

