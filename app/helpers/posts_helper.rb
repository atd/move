module PostsHelper
  def posts(resource)
    returning "" do |html|
      html << '<div id="posts">'
      if resource.posts.any?
        html << "<h2>#{ t('post.other') }</h2>"
        html << render(:partial => 'posts/post',
                       :collection => resource.posts)
      end
      html << ( resource.authorizes?([ :create, :post ], :to => current_agent) ?
                render(:partial => 'posts/new') :
                link_to(t('post.authentication_required'),
                        (site.ssl? ? login_url(:protocol => 'https') : login_path))
              )
      html << '</div>'
    end
  end
end
