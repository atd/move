class UsersController < ApplicationController
  # Include some methods and filters. 
  include ActionController::Agents
  
  # Get the User for member actions
  before_filter :get_agent, :only => [ :show, :destroy ]
  
  # Filter for activation actions
  before_filter :activation_required, :only => [ :activate, 
                                                 :forgot_password, 
                                                 :reset_password ]
  # Filter for password recovery actions
  before_filter :login_and_pass_auth_required, :only => [ :forgot_password,
                                                          :reset_password ]

  def show
    conditions = if authorized?([ :read, :Content ], @user)
                   {}
                 else
                   { :public_read => true }
                 end

    @contents = ActiveRecord::Content.all(:container => @user,
                                          :page => params[:page], 
                                          :per_page => 10, 
                                          :select => "id, title, created_at, updated_at, owner_id, owner_type",
                                         :conditions => conditions)

    respond_to do |format|
      format.html {
        if @agent.agent_options[:openid_server]
          headers['X-XRDS-Location'] = formatted_polymorphic_url([ @agent, :xrds ])
          @openid_server_agent = @agent
        end
      }
      format.atomsvc
      format.xrds
    end
  end
end