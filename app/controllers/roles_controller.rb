class RolesController < ApplicationController
  authorization_filter :update, :site
end
