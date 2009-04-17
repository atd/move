atom_feed('xmlns:app' => 'http://www.w3.org/2007/app',
          :root_url => polymorphic_url([ container, Photo.new ])) do |feed|

  feed.title(:type => "xhtml") do 
    feed.div(sanitize(title),:xmlns => "http://www.w3.org/1999/xhtml")
  end

  feed.subtitle(:type => "xhtml") do
    feed.div(sanitize(container.description), :xmlns => "http://www.w3.org/1999/xhtml")
  end if container.respond_to?(:description) && container.description.present?

  feed.updated(@photos.first.updated_at || Time.now)

  @photos.each do |photo|
    feed.entry(photo, :url => polymorphic_url([ photo.container, photo ])) do |entry|
      render :partial => 'photo',
             :object => photo,
             :locals => { :entry => entry }
    end
  end
end
