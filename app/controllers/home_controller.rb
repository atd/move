class HomeController < ApplicationController
  authentication_filter

  def index
    @appointments = current_agent.appointments

    respond_to do |format|
      format.html {
        contents
      }

      format.atom {
        contents
      }
      format.ics
    end
  end

  private

  def contents
    stages = ( Array(current_agent) | current_agent.stages | Authenticated.current.stages ) - Array(current_site)
    @contents = 
      ActiveRecord::Content.paginate(
        { :order => "updated_at DESC",
          :page => params[:page],
          :per_page => 5 },
        { :containers => stages } )
  end
end
