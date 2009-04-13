module HomeHelper
  def home_sidebar
    returning "" do |html|
      html << render(:partial => 'groups', :object => Array(current_agent) + current_agent.stages)
    end
  end
end
