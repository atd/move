# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  PUBLISHED_DATA_TIME_LIMIT = 1.month

  #FIXME
  def fixme_container
    c = current_container || respond_to?(:user) && user
    c = c.container if c.is_a?(Event) || c.is_a?(Task)
    c
  end

  def current_header
    # FIXME: DRY
    if ( ( obj = fixme_container ) && ! fixme_container.new_record? )
      container, location = obj, Array(obj)
      # Adds to location all the containers of obj
      location.unshift(container = container.parent) while container.respond_to?(:parent) && container.parent

      location = location.map{ |e| link_logotype(e) }
      location.unshift(link_logotype(current_site, :url => root_path))

      { :logo  => link_logo(obj, :size => 96),
        :title => link_to(obj.name, obj),
        :subtitle => obj.subtitle,
        :location => content_tag(:ul, location.map{ |e|
          opts = { :class => ( e == location.last ? 'current' : 'preceding' ) }
          content_tag(:li, e, opts )
        }.join)
      }
    elsif controller.controller_name == 'home'
      location = [ link_logotype(current_site, :url => root_path),
                   link_logotype(current_user),
                   link_to(image_tag('icons/apps/nepomuk.png'), home_path) +
                   link_to(t('user.home')) ]
      { :logo  => link_to(image_tag('icons/home-96.png'), home_path),
        :title => link_to(t('user.home'), home_path),
        :location => content_tag(:ul, location.map{ |e|
          opts = { :class => ( e == location.last ? 'current' : 'preceding' ) }
          content_tag(:li, e, opts)
        })
      }
    else
      { :logo => link_logo(current_site, :size => 96, :url => root_path),
        :title => link_to(current_site.name, root_path)
      }
    end
  end

  def sidebar(container = self.fixme_container)
    case container
    when User, Group
      render :partial => "#{ container.class.to_s.tableize }/sidebar",
             :locals  => 
                { container.class.to_s.underscore.to_sym => container }
    else
      render :partial => 'sites/sidebar'
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
    text ||= ""

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
