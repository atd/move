atom_entry(@audio, :root_url => polymorphic_url([ @audio.container, @audio ])) do |entry|
  render :partial => 'audio',
         :object => audio,
         :locals => { :entry => entry }
end
