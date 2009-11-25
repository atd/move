module PostsHelper
  def posts(resource)
    returning "" do |html|
      html << '<div id="posts" class="prepend-top">'
      if resource.posts.any?
        html << render(:partial => 'posts/post',
                       :collection => resource.posts)
      end
      html << ( resource.authorize?([ :create, :post ], :to => current_agent) ?
                render(:partial => 'posts/new') :
                link_to(t('post.authentication_required'),
                        with_options :redirect_to => "#{ request.request_uri }#new_post" do |r|
                          site.ssl? ?
                            r.login_url(:protocol => 'https') :
                            r.login_path
                        end 
                       )
              )
      html << '</div>'
    end
  end
end
