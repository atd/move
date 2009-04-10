class PerformancesController < ApplicationController
  authorization_filter [ :create, :performance], :stage
end
