atom_entry(@photo, :root_url => polymorphic_url([ @photo.container, @photo ])) do |entry|
  render :partial => 'photo',
         :object => photo,
         :locals => { :entry => entry }
end
