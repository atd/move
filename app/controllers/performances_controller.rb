# Require Station Controller
require_dependency "#{ RAILS_ROOT }/vendor/plugins/station/app/controllers/performances_controller"

class PerformancesController
  authorization_filter [ :read, :performance], :stage, :only => [ :index ]
  authorization_filter [ :create, :performance], :stage, :except => [ :index ]

  def index_data
    @performances = @stage.stage_performances.find(:all,
                                                   :include => :role).sort{ |x, y|
                                                     y.role <=> x.role }
    @roles = @stage.class.roles.sort{ |x, y| y <=> x }
  end
end
