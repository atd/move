# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def sidebar_menu
    current_container && current_container != current_site ?
      container_menu :
      site_menu
  end

  def site_menu
    returning "" do |html|
      html << link_logo(current_site, :size => 48, :url => root_path)
      html << sanitize(current_site.description) if current_site.description
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

  def container_menu(container = self.current_container)
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
    icon = ( agent.is_a?(User) ?
              "icons/actions/configure.png" :
              "icons/actions/user-group-properties.png" )

    returning "" do |html|
      html << link_logotype(agent, :size => 48)
      if authorized?(:update, agent)
        html << " "
        html << link_to(image_tag(icon), polymorphic_path(agent, :action => :edit), :title => t('edit'), :alt => t('edit'))
      end
      html << "<p><em>#{ sanitize agent.description }</em></p>" if agent.description.present?
    end
  end

  def performances(container)
    returning "" do |html|
      html << '<div id="performances-wrapper" class="span-6 last">'
      html << '<div id="performances" class="actions span-5">'
      html << "<ul>"
      html << "<li>"
      html << link_logo(User.new, :url => [ container, Performance.new ])
      html << link_to(t('performance.other', :scope => container.class.to_s.underscore),
                      [ container, Performance.new ])
      html << "</li>"
      html << "</div>"
      html << "</div>"
    end
  end

  def new_contents(container)
    contents = [ :document, :article, :bookmark ]

    returning "" do |html|
      html << '<div id="new_contents-wrapper" class="span-6 last">'
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
      html << "</div>"
    end
  end

  def contents(container)
    returning "" do |html|
      html << '<div id="contents" class= "span-6 last">'

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
        html << link_to(image_tag("icons/actions/document-edit.png"), polymorphic_path([ resource.container, resource ], :action => :edit), :title => t('edit'), :alt => t('edit'))
        #TODO: versions
      end
      if resource.authorizes?(:delete, :to => current_agent)
        html << ' '
        html << link_to(image_tag("icons/actions/edit-delete.png"), polymorphic_path([ resource.container, resource ]), :title => t('delete'), :alt => t('delete'), :confirm => t('confirm_delete', :scope => resource.class.to_s.underscore), :method => :delete)
      end
      html << '</div>'
    end

  end

  # This should go in some AtomHelper
  def atom_entry_author(atom_entry, content)
    atom_entry.author do |author|
      entry_author = content.author_for(current_agent)

      author.name(sanitize(entry_author.name))
      if entry_author.respond_to?(:openid_uris) && entry_author.openid_uris.any?
        author.uri(entry_author.openid_uris.first)
      end
    end

  end
end
