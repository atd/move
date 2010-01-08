class HomeController < ApplicationController
  authentication_filter

  def index
    @appointments = current_agent.appointments

    respond_to do |format|
      format.html {
        @contents = 
          ActiveRecord::Content.all(:containers => ( Array(current_agent) + current_agent.stages + Authenticated.current.stages ).uniq,
                                    :page => params[:page],
                                    :per_page => 5)
      }
      format.ics
    end
  end
end
