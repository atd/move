require_dependency "#{ RAILS_ROOT }/vendor/plugins/station/app/models/invitation"

class Invitation
  authorization_delegate :group, :as => :performance
end
