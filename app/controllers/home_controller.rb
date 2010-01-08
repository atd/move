class HomeController < ApplicationController
  authentication_filter

  def index
    @contents = 
      ActiveRecord::Content.all(:containers => ( Array(current_agent) + current_agent.stages + Authenticated.current.stages ).uniq,
                                :page => params[:page],
                                :per_page => 5)
  end
end
