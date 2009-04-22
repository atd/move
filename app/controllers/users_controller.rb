class UsersController < ApplicationController
  # Include some methods and filters. 
  include ActionController::Agents
  
  # Get the User for member actions
  before_filter :get_agent, :only => [ :show, :edit, :update, :destroy ]
  
  # Filter for activation actions
  before_filter :activation_required, :only => [ :activate, 
                                                 :lost_password, 
                                                 :reset_password ]
  # Filter for password recovery actions
  before_filter :login_and_pass_auth_required, :only => [ :lost_password,
                                                          :reset_password ]
  
  authorization_filter :update, :user, :only => [ :edit, :update ]

  def show
    conditions = {}
    conditions[:public_read] = true unless authorized?([ :read, :Content ], @user)

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

  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = t('user.updated')
        format.html { redirect_to @user }
        format.xml  { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
end
