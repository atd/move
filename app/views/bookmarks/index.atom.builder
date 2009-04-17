atom_feed('xmlns:app' => 'http://www.w3.org/2007/app',
          :root_url => polymorphic_url([ container, Bookmark.new ])) do |feed|

  feed.title(:type => "xhtml") do 
    feed.div(sanitize(title),:xmlns => "http://www.w3.org/1999/xhtml")
  end

  feed.subtitle(:type => "xhtml") do
    feed.div(sanitize(container.description), :xmlns => "http://www.w3.org/1999/xhtml")
  end if container.respond_to?(:description) && container.description.present?

  feed.updated(@bookmarks.first.updated_at || Time.now)

  @bookmarks.each do |bookmark|
    feed.entry(bookmark, :url => polymorphic_url([ bookmark.container, bookmark ])) do |entry|
      render :partial => 'bookmark',
             :object => bookmark,
             :locals => { :entry => entry }
    end
  end
end
