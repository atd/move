entry.title(:type => "xhtml") do 
  entry.div(sanitize(article.title), :xmlns => "http://www.w3.org/1999/xhtml")
end

entry.summary(:type => "xhtml") do
  entry.div(sanitize(article.description), :xmlns => "http://www.w3.org/1999/xhtml")
end if article.description.present?

entry.tag!("app:edited", article.updated_at.xmlschema)

entry.link(:rel => 'edit', :href => formatted_polymorphic_url([ article.container, article, :atom ]))
  
entry.content :type => 'xhtml' do |xhtml|
  xhtml << sanitize(article.body)
end
