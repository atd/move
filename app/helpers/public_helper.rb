module PublicHelper
  def public_menu
    returning "" do |html|
      html << "<h1>#{ t('group.other') }</h1>"
      html << '<div id="public_groups" class="groups span-7 last">'
      html << render(:partial => 'group', :collection => Group.all)
      html << '</div>'
    end
  end
end
