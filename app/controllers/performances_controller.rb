# Require Station Controller
require_dependency "#{ RAILS_ROOT }/vendor/plugins/station/app/controllers/performances_controller"

class PerformancesController
  authorization_filter [ :create, :performance], :stage
end
