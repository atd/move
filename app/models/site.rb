# Require Station Model
require_dependency "#{ RAILS_ROOT }/vendor/plugins/station/app/models/site"

class Site
  acts_as_stage
end
