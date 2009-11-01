class HomeController < ApplicationController
  authentication_filter

  def index
    @contents = 
      ActiveRecord::Content.all(:container => ( Array(current_agent) + current_agent.stages + Authenticated.current.stages ).uniq,
                                :page => params[:page],
                                :per_page => 5,
                                :select => "id, title, created_at, updated_at, owner_id, owner_type, author_id, author_type")
  end
end
