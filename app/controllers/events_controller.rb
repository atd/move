class EventsController < ApplicationController
  include ActionController::StationResources
  include CommonContents

  def index_with_conditions
    params[:order], params[:direction] = [ "start_at", "DESC" ]

    index_without_conditions
  end
  alias_method_chain :index, :conditions
end
