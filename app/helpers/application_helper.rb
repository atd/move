# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def sidebar_menu
    container && container != current_site ?
      container_menu :
      site_menu
  end

  def site_menu
    returning "" do |html|
      html << link_logo(site, :size => 48, :url => root_path)
      html << sanitize(site.description) if site.description
      html << "<hr>"
      html << "<ul>"
      html << "<li>#{ link_logotype User.new, :text => t('user.other') }</li>"
      html << "<li>#{ link_logotype Group.new, :text => t('group.other') }</li>"
      html << "<li>#{ link_logotype Article.new, :text => t('article.other') }</li>"
      html << "<li>#{ link_logotype Photo.new, :text => t('photo.other') }</li>"
      html << "<li>#{ link_logotype Audio.new, :text => t('audio.other') }</li>"
      html << "<li>#{ link_logotype Document.new, :text => t('document.other') }</li>"
      html << "<li>#{ link_logotype Bookmark.new, :text => t('bookmark.other') }</li>"
      html << "</ul>"
    end
  end

  def container_menu(container = self.container)
    return "" unless container

    returning "" do |html|
      html << agent_header(container)
      html << "<hr>"
      if container.authorizes?([ :create, :performance ], :to => current_agent)
        html << performances(container)
      end

      if container.authorizes?([ :create, :content ], :to => current_agent)
        html << new_contents(container)
      end
      html << contents(container)
    end
  end

  def agent_header(agent)
    returning "" do |html|
      html << link_logotype(agent, :size => 48)
      if authorized?(:update, agent)
        html << " " + link_to(t(:edit), polymorphic_path(agent, :action => :edit), :class => 'actions')
      end
      html << "<p><em>#{ sanitize agent.description }</em></p>" if agent.description.present?
    end
  end

  def performances(container)
    returning "" do |html|
      html << '<div id="performances" class="actions span-5">'
      html << "<ul>"
      html << "<li>"
      html << link_logo(User.new, :url => [ container, Performance.new ])
      html << link_to(t('performance.other', :scope => container.class.to_s.underscore),
                      [ container, Performance.new ])
      html << "</li>"
      html << "</div>"
    end
  end

  def new_contents(container)
    contents = [ :document, :article, :bookmark ]

    returning "" do |html|
      html << '<div id="new_contents" class="actions span-5">'
      html << "<ul>"
      contents.each do |content|
          html << "<li>"
          html << link_logo(content.to_class.new, :url => [ container, content.to_class.new ])
          html << link_to_unless_current(t(:new, :scope => content.to_s.singularize), 
                          send("new_#{ container.class.to_s.underscore }_#{ content.to_s.singularize }_path", container))
          html << "</li>"
      end
      html << "</ul>"
      html << "</div>"
    end
  end

  def contents(container)
    returning "" do |html|
      html << '<div id="contents">'

      # Contents
      html << "<ul>"
      container.class.contents.sort do |x, y| 
        t(:other, :scope => x.to_s.singularize) <=> 
        t(:other, :scope => y.to_s.singularize) 
      end.each do |content|
        if container.send(content.to_s.pluralize).count > 0
          html << "<li>"
          html << link_logo(content.to_class.new, :url => [ container, content.to_class.new ])
          html << link_to_unless_current(t(:other, :scope => content.to_s.singularize), 
                          [ container, content.to_class.new ])
          html << "</li>"
        end
      end
      html << "</ul>"

      # Categories
      if authorized?([ :read, :content ], container) && container.domain_categories.any?
        html << "<ul>"
        html << "<li>"
        html << link_logo(Category.new, :url => [ container, Category.new ])
        html << link_to_unless_current(t('category.other'), [ container, Category.new ])
        html << "<ul id=\"categories_ul\">"
        container.domain_categories.each do |c|
          html << "<li>#{ link_to sanitize(c.name), [ container, c ]}</li>"
        end
        html << "</ul>"
        html << "</li>"
      html << "</ul>"
      end

      html << "</div>"
    end
  end

  def header_session
    if authenticated?
      render :partial => 'layouts/session'
    else
      render :partial => 'layouts/login'
    end
  end

  def published_data(resource)
    returning "" do |html|
      html << '<div class="published-data">'
      action = ( resource.created_at == resource.updated_at ? 'published' : 'updated' )
      html << t("#{ action }_by_author_since_time",
                :scope => resource.class.to_s.underscore,
                :author => link_author(resource),
                :time => time_ago_in_words(resource.updated_at))
      if resource.authorizes?(:update, :to => current_agent)
        html << ' '
        html << link_to(t('edit'), send("edit_#{ resource.container.class.to_s.underscore }_#{ resource.class.to_s.underscore }_path", resource.container, resource), :class => 'actions')
        #TODO: versions
      end
      html << '</div>'
    end

  end
end
