atom_entry(@bookmark, :root_url => polymorphic_url([ @bookmark.container, @bookmark ])) do |entry|
  render :partial => 'bookmark',
         :object => bookmark,
         :locals => { :entry => entry }
end
