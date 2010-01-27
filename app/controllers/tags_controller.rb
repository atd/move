# Require Station Controller
require_dependency "#{ RAILS_ROOT }/vendor/plugins/station/app/controllers/tags_controller"

class TagsController
  authorization_filter [ :read, :content ], :path_container!, :only => [ :index ]

  def show_with_authorization
    show_without_authorization

    @taggables = @taggables.select{ |t| t.authorize?(:read, :to => current_agent) }
  end

  alias_method_chain :show, :authorization
end
