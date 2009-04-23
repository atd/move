module CommentsHelper
  def comments(resource)
    returning "" do |html|
      html << '<div id="comments">'
      if resource.comments.any?
        html << "<h2>#{ t('comment.other') }</h2>"
        html << render(:partial => 'comments/comment',
                       :collection => resource.comments)
      end
      html << ( resource.authorizes?([ :create, :comment ], :to => current_agent) ?
                render(:partial => 'comments/new') :
                link_to(t('comment.authentication_required'),
                        (site.ssl? ? login_url(:protocol => 'https') : login_path))
              )
      html << '</div>'
    end
  end
end
