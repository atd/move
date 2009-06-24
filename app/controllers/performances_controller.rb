# Require Station Controller
require_dependency "#{ RAILS_ROOT }/vendor/plugins/station/app/controllers/performances_controller"

class PerformancesController
  authorization_filter [ :create, :performance], :stage

  def index_data
    @performances = @stage.stage_performances.find(:all,
                                                   :include => :role).sort{ |x, y|
                                                     y.role <=> x.role }
    @roles = @stage.class.roles.sort{ |x, y| y <=> x }
  end
end
