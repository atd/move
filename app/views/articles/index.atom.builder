atom_feed('xmlns:app' => 'http://www.w3.org/2007/app',
          :root_url => polymorphic_url([ container, Article.new ])) do |feed|

  feed.title(:type => "xhtml") do 
    feed.div(sanitize(title),:xmlns => "http://www.w3.org/1999/xhtml")
  end

  feed.subtitle(:type => "xhtml") do
    feed.div(sanitize(container.description), :xmlns => "http://www.w3.org/1999/xhtml")
  end if container.respond_to?(:description) && container.description.present?

  feed.updated(@articles.any? && @articles.first.updated_at || Time.now)

  @articles.each do |article|
    feed.entry(article, :url => polymorphic_url([ article.container, article ])) do |entry|
      render :partial => 'article',
             :object => article,
             :locals => { :entry => entry }
    end
  end
end
