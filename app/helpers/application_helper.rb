# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  PUBLISHED_DATA_TIME_LIMIT = 1.month

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

      html << group_sidebar(container)

      html << contents(container)

      if authorized?([ :read, :content ], container) && container.tags.any?
        html << render(:partial => 'tags/sidebar_list', :locals => { :container => container })
      end
    end
  end

  def agent_header(agent)
    render :partial => "#{ agent.class.to_s.tableize }/sidebar_header",
           :locals => { agent.class.to_s.underscore.to_sym => agent }
  end

  def group_sidebar(group)
    return "" unless group.is_a?(Group)

    returning "" do |html|
      html << performances(group)

      html << group_children(group)
    end
  end

  def group_children(group)
    return "" unless group.authorize?([ :read, :performance ], :to => current_agent) &&
                     group.children.any? ||
                     group.authorize?([ :create, :performance ], :to => current_agent)

    returning "" do |html|
      html << render(:partial => 'groups/children',
                     :object => group.children,
                     :locals => { :group => group })
    end
  end

  def performances(group)
    group.authorize?([ :read, :performance ], :to => current_agent) ?
      render(:partial => 'groups/performances', :locals => { :group => group }) :
      ""
  end

  def new_contents(container)
    return "" unless container.authorize?([ :create, :content ], :to => current_agent)

    contents = [ :document, :article, :bookmark, :tasks ]

    returning "" do |html|
      html << '<div id="new_contents-wrapper" class="span-6 last">'
      html << '<div id="new_contents" class="actions span-5">'
      html << "<ul>"
      contents.each do |content_sym|
      next if container.is_a?(User) && content_sym == :tasks

        html << "<li>"
        content = content_sym.to_class.new
        content.container = container
        content_path = polymorphic_path(content, :action => :new)

        html << link_to(image_tag("models/16/#{ content_sym.to_s.singularize }-new.png", :class => 'logo'), content_path)
        html << link_to_unless_current(
                  t(:new, :scope => content_sym.to_s.singularize), 
                  content_path)
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

      html << "<h1>#{ image_tag('models/16/content.png', :class => 'logo') } #{ t('content.other') }</h1>"

      html << new_contents(container)

      html << '<div id="current_contents" class= "span-6 last">'

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

      html << "</div>"
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
      html << link_logotype(resource.author_for(current_agent))
      html << ' '

      preposition, time =
       ( Time.now - resource.updated_at > PUBLISHED_DATA_TIME_LIMIT ) ?
        [ 'at', l(resource.updated_at) ] :
        [ 'since', time_ago_in_words(resource.updated_at) ]

      html << t("#{ resource.last_action }.#{ preposition }",
                :scope => resource.class.to_s.underscore,
                :time => time )
      html << edit(resource)
      html << ' '
      html << delete(resource)
      html << '</div>'
    end

  end

  def edit(resource)
    returning "" do |html|
      if resource.authorize?(:update, :to => current_agent)
        html << ' '
        html << link_to(image_tag("icons/actions/document-edit.png"), polymorphic_path(resource, :action => :edit), :title => t('edit'), :alt => t('edit'))
        #TODO: versions
      end
    end
  end

  def delete(resource)
    returning "" do |html|
      if resource.authorize?(:delete, :to => current_agent)
        html << ' '
        html << link_to(image_tag("icons/actions/edit-delete.png"), polymorphic_path(resource), :title => t('delete'), :alt => t('delete'), :confirm => t('confirm_delete', :scope => resource.class.to_s.underscore), :method => :delete)
      end
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

  def move_format_text(text)
    move_format_text_users(text)
  end

  def move_format_text_users(text)
    text.gsub /@[\w_-]+/ do |s|
      ( user = User.find_by_login(s[1..-1].gsub('_', ' '))) ?
        link_logotype(user) : s
    end
  end

  def jquery_tags(model)
    content_for :headers do
      returning '' do |h|
        h << javascript_include_tag('jquery', 'jquery.fcbkcomplete')
        h << stylesheet_link_tag('fcbkcomplete', :media => 'screen, projection')
      end
    end
   
    content_for :javascript do
      <<-EOF
        $("##{ model }__tags").fcbkcomplete({
          cache: true,
          filter_case: false,
          filter_hide: true,
          firstselected: true,
          filter_selected: true,
          maxshownitems: 4,
          newel: true,
          complete_opts: true
        });
      EOF
    end
  end
end
