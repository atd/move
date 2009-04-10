class SessionsController < ApplicationController
  def after_create_path
    current_agent
  end
end
