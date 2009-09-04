atom_feed('xmlns:app' => 'http://www.w3.org/2007/app',
          :root_url => polymorphic_url([ container, Turn.new ])) do |feed|

  feed.title(:type => "xhtml") do 
    feed.div(sanitize(title),:xmlns => "http://www.w3.org/1999/xhtml")
  end

  feed.subtitle(:type => "xhtml") do
    feed.div(sanitize(container.description), :xmlns => "http://www.w3.org/1999/xhtml")
  end if container.respond_to?(:description) && container.description.present?

  feed.updated(@turns.first.updated_at || Time.now)

  @turns.each do |turn|
    feed.entry(turn, :url => polymorphic_url([ turn.container, turn ])) do |entry|
      render :partial => 'turn',
             :object => turn,
             :locals => { :entry => entry }
    end
  end
end
