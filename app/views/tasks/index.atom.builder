atom_feed('xmlns:app' => 'http://www.w3.org/2007/app',
          :root_url => polymorphic_url([ container, Task.new ])) do |feed|

  feed.title(:type => "xhtml") do 
    feed.div(sanitize(title),:xmlns => "http://www.w3.org/1999/xhtml")
  end

  feed.subtitle(:type => "xhtml") do
    feed.div(sanitize(container.description), :xmlns => "http://www.w3.org/1999/xhtml")
  end if container.respond_to?(:description) && container.description.present?

  feed.updated(@tasks.first.updated_at || Time.now)

  @tasks.each do |task|
    feed.entry(task, :url => polymorphic_url([ task.container, task ])) do |entry|
      render :partial => 'task',
             :object => task,
             :locals => { :entry => entry }
    end
  end
end
