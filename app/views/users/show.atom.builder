atom_feed('xmlns:app' => 'http://www.w3.org/2007/app',
          :root_url => polymorphic_url(@user)) do |feed|

  feed.title(sanitize(@user.title))

  feed.subtitle(:type => "xhtml") do
    feed.div(sanitize(@user.subtitle), :xmlns => "http://www.w3.org/1999/xhtml")
  end if @user.subtitle.present?

  feed.updated(@contents.any? && @contents.first.updated_at || Time.now)

  @contents.each do |content|
    feed.entry(content, :url => polymorphic_url(content)) do |entry|
      render :partial => "#{ content.class.name.tableize }/#{ content.class.name.underscore }",
             :object => content.reload,
             :locals => { :entry => entry }
    end
  end
end
