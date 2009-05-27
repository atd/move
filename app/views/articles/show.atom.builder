atom_entry(@article, :root_url => polymorphic_url([ @article.container, @article ])) do |entry|
  render :partial => 'article',
         :object => article,
         :locals => { :entry => entry }
end
