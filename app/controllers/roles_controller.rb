# Require Station Controller
require_dependency "#{ RAILS_ROOT }/vendor/plugins/station/app/controllers/roles_controller"

class RolesController
  authorization_filter :update, :site
end
