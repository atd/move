# Require Station Controller
require_dependency "#{ RAILS_ROOT }/vendor/plugins/station/app/controllers/invitations_controller"

class InvitationsController
  authorization_filter :create, :invitation, :only => [ :new, :create ]
  authorization_filter :read, :invitation, :only => [ :index, :show ]
  authorization_filter :update, :invitation, :only => [ :edit, :update ]
  authorization_filter :delete, :invitation, :only => [ :destroy ]
end
