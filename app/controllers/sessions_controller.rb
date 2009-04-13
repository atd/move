class SessionsController < ApplicationController
  def after_create_path
    home_path
  end
end
