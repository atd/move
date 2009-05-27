atom_entry(@document, :root_url => polymorphic_url([ @document.container, @document ])) do |entry|
  render :partial => 'document',
         :object => document,
         :locals => { :entry => entry }
end
