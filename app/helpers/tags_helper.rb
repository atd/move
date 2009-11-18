module TagsHelper
  def tags(taggable)
    returning "" do |html|
      html << "<div id=\"#{ dom_id(taggable) }_tags\" class=\"tags\">"

      if taggable.tags.any?
        html << taggable.tags.map{ |t| link_logotype(t, :rel => 'tag') }.join(' ')
      end
      html << '</div>'
    end
  end
end
