class RolesController < ApplicationController
  authorization_filter :mat, :site
end
