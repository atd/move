class EventsController < ApplicationController
  include ActionController::StationResources
  include CommonContents

  def index_with_conditions
    params[:order], params[:direction] = [ "start_at", "DESC" ]

    index_without_conditions do
      respond_to do |format|
        format.html
        format.js
        format.xml { render :xml => @resources }
        format.atom
        format.ics
      end
    end
  end
  alias_method_chain :index, :conditions
end
