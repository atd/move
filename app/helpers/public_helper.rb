module PublicHelper
  def public_menu
    returning "" do |html|
      html << "<h1>#{ t('group.other') }</h1>"
      html << '<div id="public_groups" class="groups span-7 last">'
      html << if Group.count > 0
                render(:partial => 'group', :collection => Group.all)
              else 
                t('group.none')
              end
      html << '</div>'
    end
  end
end
