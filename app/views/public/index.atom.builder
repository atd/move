atom_feed do |feed|

  feed.title(sanitize(current_site.name))

  feed.subtitle(:type => "xhtml") do
    feed.div(sanitize(current_site.description), :xmlns => "http://www.w3.org/1999/xhtml")
  end if current_site.description.present?

  feed.updated(@contents.any? && @contents.first.updated_at || Time.now)

  @contents.each do |content|
    feed.entry(content, :url => polymorphic_url([ content.container, content ])) do |entry|
      entry.title(sanitize(content.title))

      atom_entry_author(entry, content)

      entry.content :type => 'xhtml' do |xhtml|
        xhtml << render(:partial => 'content.html.erb', :object => content)
      end
      
    end
  end
end
