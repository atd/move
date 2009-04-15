class SitesController < ApplicationController
  authorization_filter :update, :site
end
