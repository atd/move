atom_feed('xmlns:app' => 'http://www.w3.org/2007/app',
          :root_url => polymorphic_url([ container, Audio.new ])) do |feed|

  feed.title(:type => "xhtml") do 
    feed.div(sanitize(title),:xmlns => "http://www.w3.org/1999/xhtml")
  end

  feed.subtitle(:type => "xhtml") do
    feed.div(sanitize(container.description), :xmlns => "http://www.w3.org/1999/xhtml")
  end if container.respond_to?(:description) && container.description.present?

  feed.updated(@audios.any? && @audios.first.updated_at || Time.now)

  @audios.each do |audio|
    feed.entry(audio, :url => polymorphic_url([ audio.container, audio ])) do |entry|
      render :partial => 'audio',
             :object => audio,
             :locals => { :entry => entry }
    end
  end
end
