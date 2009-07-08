atom_feed do |feed|

  feed.title(:type => "xhtml") do 
    feed.div(title(t('user.home'), :append_site_name => true),:xmlns => "http://www.w3.org/1999/xhtml")
  end

  feed.updated(@contents.any? && @contents.first.updated_at || Time.now)

  @contents.each do |content|
    feed.entry(content, :url => polymorphic_url([ content.container, content ])) do |entry|
      entry.title(sanitize(content.title))
      entry.content :type => 'xhtml' do |xhtml|
        xhtml << render(:partial => 'content.html.erb', :object => content)
      end
      
    end
  end
end
