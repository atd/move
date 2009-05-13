# Require Station Controller
require_dependency "#{ RAILS_ROOT }/vendor/plugins/station/app/controllers/sessions_controller"

class SessionsController
  def after_create_path
    home_path
  end
end
