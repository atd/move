atom_feed('xmlns:app' => 'http://www.w3.org/2007/app',
          :root_url => polymorphic_url([ container, Document.new ])) do |feed|

  feed.title(:type => "xhtml") do 
    feed.div(sanitize(title),:xmlns => "http://www.w3.org/1999/xhtml")
  end

  feed.subtitle(:type => "xhtml") do
    feed.div(sanitize(container.description), :xmlns => "http://www.w3.org/1999/xhtml")
  end if container.respond_to?(:description) && container.description.present?

  feed.updated(@documents.any? && @documents.first.updated_at || Time.now)

  @documents.each do |document|
    feed.entry(document, :url => polymorphic_url([ document.container, document ])) do |entry|
      render :partial => 'document',
             :object => document,
             :locals => { :entry => entry }
    end
  end
end
