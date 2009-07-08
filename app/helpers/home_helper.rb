module HomeHelper
  def home_sidebar
    returning "" do |html|
      html << "<h1>#{ t('user.group.other') }</h1>"
      html << '<div id="home-sidebar">'
      html << render(:partial => 'groups', :object => Array(current_agent) + current_agent.stages)
      html << '<div id="new-group" class="actions span-6">'
      html << link_to("#{ logo(Group.new) } #{  t('group.new') }", new_group_path)
      html << '</div>'
      html << '</div>'
    end
  end
end
