entry.title(:type => "xhtml") do 
  entry.div(sanitize(task.title), :xmlns => "http://www.w3.org/1999/xhtml")
end

entry.summary(:type => "xhtml") do
  entry.div(sanitize(task.description), :xmlns => "http://www.w3.org/1999/xhtml")
end if task.description.present?

entry.tag!("app:edited", task.updated_at.xmlschema)

entry.link(:rel => 'edit', :href => polymorphic_url([ task.container, task], :format => :atom ]))
  
url_args = ( task.respond_to?(:container) && task.container ? [ task.container, task ] : task )

options = {}
options[:src], options[:type] = ( task.format ?
  [ polymorphic_url(url_args, :format => task.format), task.mime_type.to_s ] :
  [ polymorphic_url(url_args), 'text/html' ] )

entry.content(options)
