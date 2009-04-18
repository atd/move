module CommentsHelper
  def comments(resource)
    returning "" do |html|
      html << '<div id="comments">'
      if resource.comments.any?
        html << "<h2>#{ t('comment.other') }</h2>"
        html << render(:partial => 'comments/comment',
                       :collection => resource.comments)
      end
      if resource.authorizes?([ :create, :comment ], :to => current_agent)
        html << render(:partial => 'comments/new')
      end
      html << '</div>'
    end
  end
end
