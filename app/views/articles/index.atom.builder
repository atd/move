atom_feed('xmlns:app' => 'http://www.w3.org/2007/app',
          :root_url => polymorphic_url([ container, Article.new ])) do |feed|

  feed.title(:type => "xhtml") do 
    feed.div(sanitize(title),:xmlns => "http://www.w3.org/1999/xhtml")
  end

  feed.subtitle(:type => "xhtml") do
    feed.div(sanitize(container.description), :xmlns => "http://www.w3.org/1999/xhtml")
  end if container.respond_to?(:description) && container.description.present?

  feed.updated(@articles.first.updated_at || Time.now)

  for article in @articles
    feed.entry(article, :url => polymorphic_url([ article.container, article ])) do |atom_entry|

      atom_entry.title(:type => "xhtml") do 
        atom_entry.div(sanitize(article.title), :xmlns => "http://www.w3.org/1999/xhtml")
      end

      atom_entry.summary(:type => "xhtml") do
        atom_entry.div(sanitize(article.description), :xmlns => "http://www.w3.org/1999/xhtml")
      end if article.description.present?

      atom_entry.tag!("app:edited", article.updated_at.xmlschema)

      atom_entry.link(:rel => 'edit', :href => formatted_polymorphic_url([ article.container, article, :atom ]))
      
      atom_entry << render(:partial => 'atom_entry',
                           :object => atom_entry,
                           :locals => { :article => article })

    end
  end
end
