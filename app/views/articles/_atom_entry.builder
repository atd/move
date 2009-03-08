atom_entry.content(:type => 'xhtml') do
  atom_entry.div(sanitize(article.body), :xmlns => "http://www.w3.org/1999/xhtml")
end
