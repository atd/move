# Require Station Controller
require_dependency "#{ RAILS_ROOT }/vendor/plugins/station/app/controllers/invitations_controller"

class InvitationsController
  authorization_filter [ :create, :performance], :group, :only => [ :new, :create ]
end
